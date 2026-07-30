---
description: Prefer classes, design patterns where they fit, reuse existing APIs, and keep control flow flat
alwaysApply: true
inclusion: always
---

# Code Design Preferences

Prefer structure over inline logic. When adding or changing behavior, put domain rules on the types that own the state.

## Prefer classes and existing APIs

- Put behavior on the class that owns the data (e.g. `Order.belongs_to`), not as a long block in the caller.
- Before writing new helpers, search for existing methods/functions on nearby models, services, and utils and reuse or extend them.
- Prefer a small method with a clear name over a multi-line conditional inlined at the call site.
- Prefer patterns already used in the codebase over inventing parallel ones.
- If a well-known pattern fits but is not listed here, suggest it and say why before introducing it.

## Flat control flow

- Prefer early returns over nested `if`/`else`.
- Avoid nesting deeper than two levels; extract a method or combine conditions instead.
- Guard clauses first, happy path last and unindented.

## Design principles

- **Composition over inheritance** — prefer “has-a” (strategy, injected deps) over deep class hierarchies.
- **Tell, don’t ask** — don’t pull fields out of an object and decide elsewhere; ask the object to do the work or answer the question.
- **Law of Demeter** — don’t reach through an object into *its* collaborators (`a.getB().getC().x`). Expose a method on the top-level object instead (`a.get_owner_id(...)`, `a.belongs_to(...)`).
- **Separation of construction and use** — factories/DI build the object graph; business methods should not `new` their collaborators mid-flow.
- **Domain language in names** — methods and types should match the business question (`belongs_to`, not `check_ids`; `PaymentProcessor`, not `Handler2`).
- **Immutability for value-like data** — prefer not mutating shared domain graphs in place; update via copy/builder/new instance when representing values or snapshots. Avoid void functions that mutate a parameter and return nothing — prefer returning the new/updated value (or an explicit result) so call sites see the data flow. Mutate in place only when that is the clear, local ownership model (e.g. a builder accumulating state) and the name makes the side effect obvious.
- **Idempotency at boundaries** — design handlers for queues, schedulers, and HTTP so retries are safe (same event twice should not double-apply side effects).

## When to use which pattern

Selection rule:

- Same role, multiple implementations → interface + factory.
- Same step, different runtime approach → strategy.
- Only the data owner can answer → method on that class.
- One-off, not branching by type → keep it simple; do not pattern-ize.

| Pattern | Use when |
| --- | --- |
| **Strategy** | Different runtime algorithms for the same step (e.g. card vs wallet payment, daily vs weekly digest). |
| **Factory** | Choosing among multiple implementations behind one interface. |
| **Interface** | Two or more real implementations of the same role. Do not add an interface for a single implementation “for later.” An interface is the *contract*; a strategy is a *runtime choice* among implementations of that contract. |
| **Template method / orchestrator + hooks** | Fixed pipeline (validate → decide → act → cleanup) with strategy hooks for the varying parts. |
| **Null Object / no-op** | Avoid `if x is None` branches in the main flow; a no-op implementation keeps the caller flat. |
| **Facade / thin service** | Handlers/lambdas/controllers stay wiring only; domain rules live on models/services. |
| **Guard / specification (light)** | A “should we proceed?” question as a named method on the owning type, not a compound conditional in the orchestrator. |
| **Adapter** | System boundaries only (AWS, HTTP, etc.) when you need a stable internal API over an awkward external one. |
| **Decorator** | Wrap an interface for cross-cutting concerns (retry, metrics, logging, auth) without changing the core implementation. |
| **Singleton / shared instance** | One shared service/client for the process — framework `@Service` / `@Component` beans, module-level service instances, shared cloud clients. Prefer the framework’s or language’s normal “one instance, injected/imported everywhere” style over hand-rolled singleton boilerplate. |
| **Builder** | Constructing complex objects with many optional/required fields, nested structure, or multi-step assembly where a telescoping constructor would be unclear. |
| **Repository** | When it adds real domain query/persistence semantics (find-by-criteria, aggregate load/save). Fine as the persistence boundary; do not wrap an already-thin client in another pass-through layer that only forwards calls. |
| **Dependency injection** | Pass collaborators in (constructor/params/framework DI) instead of hard-wiring globals inside the unit. Makes boundaries swappable in tests and keeps orchestration thin. Examples: inject a repository instead of constructing the DB client inside the service; inject a clock/`now` provider instead of calling `datetime.now()` so time-sensitive logic can be tested with a fixed instant. Prefer the framework’s DI or simple constructor injection over service locators and hidden imports of concrete clients. |
| **Result / explicit outcomes** | Expected domain outcomes (ended, skipped, conflict, success) as a result type rather than overloading exceptions for normal control flow. |

### Classic composition

Patterns usually combine. A common shape:

1. **Interface** — e.g. `PaymentProcessor` with `should_process` / `process`.
2. **Strategies** — e.g. `CardProcessor`, `WalletProcessor` implementing that interface.
3. **Factory** — accepts a type/discriminator (`CARD` vs `WALLET`) and returns the matching strategy.
4. **DI + singleton services** — the factory (or the container that builds it) injects shared collaborators into each strategy: repositories, messaging clients, a clock. Those collaborators are process-wide singletons/beans; the strategies may be created per request or also be singletons that hold those deps.

```text
Container/DI
  └── ProcessorFactory(repo, clock, ...)   # factory gets singleton deps
        ├── create("CARD")   → CardProcessor(repo, clock)
        └── create("WALLET") → WalletProcessor(repo, clock)
```

Other familiar pairings: orchestrator/template method that *uses* a strategy; builder that produces a complex domain object later saved via an injected repository; decorator wrapping a strategy for retries/metrics.

## Anti-patterns

```text
# BAD — jam domain logic into the orchestrator / Law of Demeter violation
payment_details = order.get_payment_details()
customer_id = payment_details.billing.customerId
if payment_details is None or (a is not None and b is not None and a != b):
    ...

# GOOD — tell the owning object / Demeter-friendly API
if not order.belongs_to(customer_id):
    ...
```

Do not create speculative abstractions. Extract when the behavior has a clear home on an existing type or when nesting/inline complexity appears.
