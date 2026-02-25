const dns = require('dns');
const origLookup = dns.lookup;
dns.lookup = function(hostname, options, callback) {
  if (typeof options === 'function') { callback = options; options = {}; }
  options = typeof options === 'number' ? { family: options } : { ...options };
  options.family = 4;
  return origLookup.call(dns, hostname, options, callback);
};
