# Contributing to LegacyBank

Thank you for your interest in LegacyBank! This is a demonstration project designed to showcase legacy patterns for modernization training.

## Purpose

This application is intentionally built with legacy patterns to demonstrate:
- Migration from .NET Framework to .NET 8+
- Strangler fig pattern for gradual modernization
- Microservices extraction from a monolith
- Security improvements (secrets management, authentication)
- Observability with OpenTelemetry
- Modern data access patterns with EF Core

## Legacy Patterns (DO NOT "FIX")

The following patterns are **intentional** and should **NOT** be removed:

### Data Access
- Inline SQL with string concatenation
- Mixed ADO.NET and helper patterns
- N+1 query anti-patterns
- No ORM/no Entity Framework

### Architecture
- Synchronous SOAP/WCF calls
- DataSet usage
- No async/await
- No dependency injection

### Security
- Secrets in web.config
- SQL injection risks (demo only)
- No authentication/authorization
- Exposed configuration page

### Performance
- In-memory filtering
- Blocking I/O operations
- Session/Cache misuse

## How to Contribute

### Adding New Legacy Patterns

If you'd like to add more legacy patterns for demonstration:

1. **Fork the repository**
2. **Create a feature branch** with a descriptive name
3. **Add your legacy pattern** with clear documentation of what makes it "legacy"
4. **Update the README** to document the new smell
5. **Submit a pull request** with:
   - Description of the legacy pattern
   - Why it's considered legacy
   - What modern alternative exists

### Adding Modernization Examples

If you'd like to add modernization examples:

1. **Create a new branch** prefixed with `modernization/`
2. **Implement the modern pattern** alongside the legacy version
3. **Document the migration path** in a separate markdown file
4. **Include before/after comparisons**
5. **Submit a pull request**

### Documentation Improvements

Documentation improvements are always welcome:
- Clearer setup instructions
- Additional architecture diagrams
- More detailed legacy pattern explanations
- Modernization roadmap documentation

### Bug Reports

If you find actual bugs (not intentional legacy patterns):

1. **Check the README** - it might be intentional!
2. **Open an issue** describing:
   - What you expected to happen
   - What actually happened
   - Steps to reproduce
   - Whether this prevents the demo from working

## Code Style

Since this is a legacy application, we're **not** enforcing modern code style. However:

- Keep code readable and well-commented
- Explain why each legacy pattern exists
- Use clear variable and method names
- Add XML documentation for public APIs

## Testing

This project does not include automated tests (intentionally, as legacy code often lacks tests). If adding modernization examples:

- Modern code SHOULD include unit tests
- Use this as an opportunity to show the value of testing
- Document how to add tests to legacy code

## Pull Request Process

1. Update the README with details of changes
2. Update setup instructions if needed
3. Ensure the application still builds and runs
4. Get approval from a maintainer

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Questions?

Open an issue or discussion on GitHub if you have questions about contributing.

---

Remember: This is a teaching tool. The "bad" code is intentional. Focus on demonstrating patterns and migration paths, not on making the legacy code "perfect."
