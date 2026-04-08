# Stack Detection Heuristics

## Detection Priority Order
1. Language → 2. Framework → 3. Database/ORM → 4. Testing → 5. Deployment → 6. CI/CD → 7. Package Manager → 8. Additional signals

## Language Detection

| File Indicator | Language | Confidence |
|---------------|----------|-----------|
| `package.json` + `tsconfig.json` | TypeScript | High |
| `package.json` only | JavaScript | High |
| `Cargo.toml` | Rust | High |
| `go.mod` | Go | High |
| `pyproject.toml` | Python | High |
| `requirements.txt` | Python | Medium |
| `pom.xml` | Java | High |
| `build.gradle.kts` | Kotlin | High |
| `build.gradle` | Java/Groovy | Medium |
| `Gemfile` | Ruby | High |
| `*.csproj` / `*.sln` | C# | High |
| `Package.swift` | Swift | High |
| `mix.exs` | Elixir | High |
| `pubspec.yaml` | Dart/Flutter | High |

## Framework Detection

### JavaScript/TypeScript Frameworks
| Indicator | Framework | Key Config |
|-----------|-----------|-----------|
| `next.config.*` | Next.js | Check version in package.json |
| `nuxt.config.*` | Nuxt.js | Check for v3 (TypeScript) vs v2 |
| `angular.json` | Angular | Check `@angular/core` version |
| `vite.config.*` | Vite | Check for React/Vue/Svelte/Solid plugin |
| `remix.config.*` or `@remix-run` | Remix | Check v2 vs v1 |
| `astro.config.*` | Astro | Check integrations |
| `svelte.config.*` | SvelteKit | Check adapter |
| `express` in deps | Express | Standalone or with framework |
| `@nestjs/core` in deps | NestJS | Check version |
| `hono` in deps | Hono | Check runtime adapter |

### Next.js Sub-detection
- **App Router**: `src/app/` or `app/` directory with `layout.tsx`
- **Pages Router**: `pages/` directory with `_app.tsx`
- **Version**: Read from `package.json` dependencies

### Python Frameworks
| Indicator | Framework |
|-----------|-----------|
| `django` in deps | Django |
| `flask` in deps | Flask |
| `fastapi` in deps | FastAPI |
| `starlette` in deps | Starlette |

### Java/Kotlin Frameworks
| Indicator | Framework |
|-----------|-----------|
| `spring-boot` in deps | Spring Boot |
| `io.ktor` in deps | Ktor |
| `micronaut` in deps | Micronaut |

### Go Frameworks
| Indicator | Framework |
|-----------|-----------|
| `github.com/gin-gonic/gin` | Gin |
| `github.com/labstack/echo` | Echo |
| `github.com/gofiber/fiber` | Fiber |

## Database & ORM Detection

| Indicator | ORM | DB Type Detection |
|-----------|-----|-------------------|
| `prisma/schema.prisma` | Prisma | Read `provider` from datasource block |
| `drizzle.config.*` | Drizzle | Read dialect from config |
| `knexfile.*` | Knex | Read client from config |
| `sequelize` in deps | Sequelize | Read dialect from config |
| `typeorm` in deps | TypeORM | Read type from ormconfig |
| `sqlalchemy` in deps | SQLAlchemy | Read URL from config |
| `django.db` usage | Django ORM | Read DATABASES from settings |
| `diesel.toml` | Diesel | Read from Cargo.toml features |
| `entgo.io/ent` | Ent | Read from schema |
| `mongoose` in deps | Mongoose | MongoDB |
| `@supabase/supabase-js` | Supabase | PostgreSQL |

### Multi-Schema Detection (Prisma)
- Glob for `prisma/schema*.prisma` or `*/schema.prisma`
- Count schema files
- Extract datasource names and providers

## Testing Detection

| Indicator | Framework | Type |
|-----------|-----------|------|
| `vitest` in devDeps | Vitest | Unit |
| `jest` in devDeps or `jest.config.*` | Jest | Unit |
| `@playwright/test` in devDeps | Playwright | E2E |
| `cypress` in devDeps | Cypress | E2E |
| `pytest` in deps | Pytest | Unit |
| `@testing-library/react` in devDeps | React Testing Library | Component |
| `junit` in deps | JUnit | Unit |
| `kotest` in deps | Kotest | Unit |
| `go test` convention | Go testing | Unit |
| `cargo test` convention | Rust testing | Unit |

## Deployment Detection

| Indicator | Target | Category |
|-----------|--------|----------|
| `Dockerfile` | Docker | Container |
| `docker-compose.*` | Docker Compose | Container |
| `vercel.json` or `@vercel/node` | Vercel | Serverless |
| `netlify.toml` | Netlify | Serverless |
| `fly.toml` | Fly.io | Container |
| `railway.json` | Railway | Container |
| `render.yaml` | Render | Container |
| `serverless.yml` | Serverless Framework | Serverless |
| `template.yaml` + `AWSTemplateFormatVersion` | AWS SAM | Serverless |
| `cdk.json` | AWS CDK | IaC |
| K8s manifests (`apiVersion: apps/v1`) | Kubernetes | Container |
| `.terraform/` or `*.tf` | Terraform | IaC |
| `Procfile` | Heroku | PaaS |
| `app.yaml` (GAE) | Google App Engine | PaaS |

## CI/CD Detection

| Indicator | Provider |
|-----------|----------|
| `.github/workflows/*.yml` | GitHub Actions |
| `.gitlab-ci.yml` | GitLab CI |
| `Jenkinsfile` | Jenkins |
| `bitbucket-pipelines.yml` | Bitbucket Pipelines |
| `.circleci/config.yml` | CircleCI |
| `cloudbuild.yaml` | Google Cloud Build |
| `azure-pipelines.yml` | Azure DevOps |

## Additional Signal Detection

### Authentication
| Indicator | Auth Provider |
|-----------|--------------|
| `next-auth` in deps | NextAuth.js |
| `@clerk/nextjs` in deps | Clerk |
| `@auth0/nextjs-auth0` | Auth0 |
| `@supabase/auth-helpers` | Supabase Auth |
| `firebase/auth` | Firebase Auth |
| `passport` in deps | Passport.js |
| `django-allauth` | Django Allauth |

### LLM Integration
| Indicator | Provider |
|-----------|----------|
| `@anthropic-ai/sdk` | Anthropic Claude |
| `openai` in deps | OpenAI |
| `@google/genai` | Google Gemini |
| `langchain` in deps | LangChain |
| `llamaindex` in deps | LlamaIndex |
| `@ai-sdk/` in deps | Vercel AI SDK |

### CSS Framework
| Indicator | Framework |
|-----------|-----------|
| `tailwindcss` in devDeps | Tailwind CSS |
| `styled-components` in deps | styled-components |
| `@emotion/react` in deps | Emotion |
| `sass` in devDeps | SASS/SCSS |
| CSS Modules (`.module.css` files) | CSS Modules |

### Monorepo
| Indicator | Tool |
|-----------|------|
| `pnpm-workspace.yaml` | pnpm workspaces |
| `lerna.json` | Lerna |
| `nx.json` | Nx |
| `turbo.json` | Turborepo |
| `rush.json` | Rush |
