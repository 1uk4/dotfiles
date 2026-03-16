#!/usr/bin/env node
// Google Calendar API helper — called by gcal.sh
// Never outputs credentials, only calendar data

const { google } = require('googleapis');
const fs = require('fs');

const [,, cmd, credsPath, ...args] = process.argv;

async function getCalendar() {
  const creds = JSON.parse(fs.readFileSync(credsPath, 'utf8'));
  const auth = new google.auth.GoogleAuth({
    credentials: creds,
    scopes: ['https://www.googleapis.com/auth/calendar'],
  });
  const calendar = google.calendar({ version: 'v3', auth });
  // Calendar ID will be set after sharing — default to primary or env
  const calendarId = 'audemears@gmail.com';
  return { calendar, calendarId };
}

async function listEvents(date) {
  const { calendar, calendarId } = await getCalendar();
  const timeMin = new Date(`${date}T00:00:00`).toISOString();
  const timeMax = new Date(`${date}T23:59:59`).toISOString();
  
  const res = await calendar.events.list({
    calendarId,
    timeMin,
    timeMax,
    singleEvents: true,
    orderBy: 'startTime',
  });

  const events = res.data.items || [];
  if (events.length === 0) {
    console.log(`No events on ${date}`);
    return;
  }
  events.forEach(e => {
    const start = e.start.dateTime || e.start.date;
    const end = e.end.dateTime || e.end.date;
    console.log(`${e.id} | ${start} → ${end} | ${e.summary || '(no title)'}${e.description ? ' | ' + e.description : ''}`);
  });
}

async function addEvent(title, start, end, description) {
  const { calendar, calendarId } = await getCalendar();
  const event = {
    summary: title,
    start: { dateTime: start, timeZone: 'America/Los_Angeles' },
    end: { dateTime: end, timeZone: 'America/Los_Angeles' },
  };
  if (description) event.description = description;

  const res = await calendar.events.insert({ calendarId, resource: event });
  console.log(`Created: ${res.data.id} | ${res.data.summary}`);
}

async function deleteEvent(eventId) {
  const { calendar, calendarId } = await getCalendar();
  await calendar.events.delete({ calendarId, eventId });
  console.log(`Deleted: ${eventId}`);
}

async function updateEvent(eventId, field, value) {
  const { calendar, calendarId } = await getCalendar();
  const patch = {};
  if (field === 'title') patch.summary = value;
  else if (field === 'description') patch.description = value;
  else if (field === 'start') patch.start = { dateTime: value, timeZone: 'America/Los_Angeles' };
  else if (field === 'end') patch.end = { dateTime: value, timeZone: 'America/Los_Angeles' };
  else { console.error(`Unknown field: ${field}`); process.exit(1); }

  const res = await calendar.events.patch({ calendarId, eventId, resource: patch });
  console.log(`Updated: ${res.data.id} | ${res.data.summary}`);
}

(async () => {
  try {
    switch (cmd) {
      case 'list': await listEvents(args[0]); break;
      case 'add': await addEvent(args[0], args[1], args[2], args[3]); break;
      case 'delete': await deleteEvent(args[0]); break;
      case 'update': await updateEvent(args[0], args[1], args[2]); break;
      default: console.error(`Unknown cmd: ${cmd}`); process.exit(1);
    }
  } catch (err) {
    // Never output full error (may contain credential info)
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
})();
