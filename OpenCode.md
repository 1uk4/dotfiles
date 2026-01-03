# OpenCode Configuration

## Build/Test Commands
- `npm run dev` - Start development server
- `npm run build` - Production build with GeoLite2 download
- `npm run lint` - Run ESLint
- `npm test` - Run all tests
- `jest path/to/test.test.ts` - Run single test file
- `npm run test:watch` - Run tests in watch mode
- `npm run test:mongo` - Run MongoDB-specific tests

## OpenCode Session Management

### Session Manager Script: `oc`
A comprehensive session management tool that integrates with your tmux + neovim workflow.

#### Commands
- `oc start [name] [dir]` - Start new OpenCode session
- `oc stop` - Stop current OpenCode session  
- `oc list` - List all sessions with IDs, dates, and message counts
- `oc switch <id>` - Switch to session by ID (supports partial IDs)
- `oc new [name] [context]` - Create new session with context
- `oc status` - Show current session status
- `oc save [name]` - Save current session context to file
- `oc load <name>` - Load session context from file
- `oc cleanup [days]` - Clean up old sessions (default: 7 days)
- `oc stats` - Show session statistics and usage patterns
- `oc help` - Show detailed help

#### Neovim Integration Keybindings
- `<leader>oo` - Toggle OpenCode connection
- `<leader>oa` - Ask OpenCode with context
- `<leader>of` - Ask about current file (@file context)
- `<leader>on` - New OpenCode session
- `<leader>oe` - Explain code at cursor (@cursor context)
- `<leader>or` - Review current file
- `<leader>od` - Document selection (visual mode)
- `<leader>ob` - Bug analysis
- `<leader>op` - Performance optimization
- `<leader>ot` - Generate tests
- `<leader>oR` - Refactor selection (visual mode)
- `<leader>oc` - Add comments
- `<leader>os` - Suggest improvements
- `<leader>oq` - Quick explain word under cursor
- `<leader>oh` - OpenCode help

#### Session Management Keybindings
- `<leader>ol` - List OpenCode sessions
- `<leader>oS` - Save current session context
- `<leader>ox` - Stop OpenCode session
- `<leader>oL` - Load session context (prompts for name)
- `<leader>oN` - Create new session (prompts for name/context)
- `<leader>oT` - Show session statistics

#### Workflow Integration
- **Auto-naming**: Sessions are automatically named based on tmux session and project directory
- **Context saving**: Captures project structure, git history, and session metadata
- **Tmux integration**: Seamlessly works with existing `ide` script and pane management
- **Database queries**: Direct SQLite access to OpenCode's session database

#### Example Workflows

1. **Start a focused coding session**:
   ```bash
   oc start bug-fix ~/myproject
   # Opens OpenCode in tmux split, focused on specific directory
   ```

2. **Save and restore session context**:
   ```bash
   oc save current-work
   # Later...
   oc load current-work
   ```

3. **Session management**:
   ```bash
   oc list                    # See all sessions
   oc switch e97702d0         # Switch to specific session (partial ID works)
   oc stats                   # View usage statistics
   ```

4. **Cleanup old sessions**:
   ```bash
   oc cleanup 14              # Remove context files older than 14 days
   ```

### Files Created
- `/Users/lukaflores/dotfiles/bin/oc` - Main session manager script
- `/Users/lukaflores/dotfiles/bin/oc-demo` - Demo data generator
- `~/.opencode/sessions/*.ctx` - Saved session contexts

## Code Style Guidelines

### Imports & Organization
- Use absolute imports with `@/` alias: `import { Component } from '@/src/components/Component'`
- Group imports: external libraries first, then internal modules
- Separate type imports when needed

### TypeScript & Validation
- Use strict TypeScript with Zod schemas for validation
- Define schemas in `/schemas` directory, infer types: `type Game = z.infer<typeof gameSchema>`
- PascalCase for components: `UserProfileDialog`, `GameCreationCard`
- Use descriptive, feature-based naming conventions

### Error Handling
- Always use try-catch in API routes and services
- Return structured responses: `{ success: boolean, data?: T, error?: string }`
- Use toast notifications for user-facing errors
- Log errors with context: `console.error('Error creating game:', error)`

### Architecture Patterns
- API Routes: `/src/app/api/[feature]/[action]/route.ts` (Next.js 13+ App Router)
- Services: `/services/[Feature]/[feature].service.ts` (business logic)
- Use session-based auth: `const session = await getServerSession()` (never pass userId in requests)
- Hooks use `useAuthenticatedQuery`/`useAuthenticatedMutation` with React Query
- All API calls use standardized format with `api` middleware