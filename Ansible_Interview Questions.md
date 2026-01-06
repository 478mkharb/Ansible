# Hardest Ansible Interview Questions (Advanced & Scenario-Based)

This document contains **deep, real-world, hardest Ansible interview questions** asked for **Senior DevOps / SRE / Platform Engineer** roles.

Each question includes **clear, concise, technically correct answers** with **interview-grade depth**.

---

## 1. What makes an Ansible task idempotent?

### Answer:

A task is idempotent if **running it multiple times produces the same final state** without additional changes.

Ansible modules achieve idempotency by:

* Checking current system state
* Making changes only if required
* Returning `changed: false` if no action is needed

❌ Shell/command modules are **not idempotent by default**.

---

## 2. Difference between `command`, `shell`, and `raw` modules

### Answer:

| Module  | Shell Features | Idempotent | Use Case                        |
| ------- | -------------- | ---------- | ------------------------------- |
| command | ❌              | ❌          | Simple commands                 |
| shell   | ✅              | ❌          | Pipes, redirects                |
| raw     | ❌              | ❌          | Bootstrapping Python-less hosts |

---

## 3. How does Ansible handle parallelism internally?

### Answer:

* Controlled by `forks` (default: 5)
* Each host runs in parallel using **SSH connections**
* Tasks execute **serially per host** but **parallel across hosts**

Advanced control:

* `serial`
* `throttle`
* `strategy: free`

---

## 4. Difference between `import_tasks` and `include_tasks`

### Answer:

| Aspect     | import_tasks | include_tasks |
| ---------- | ------------ | ------------- |
| Evaluation | Parse time   | Runtime       |
| Dynamic    | ❌            | ✅             |
| Loops/when | ❌            | ✅             |

Interview tip:

> Use `include_tasks` for dynamic behavior.

---

## 5. What happens if `gather_facts` is disabled?

### Answer:

* `ansible_*` facts are unavailable
* Faster execution
* You must manually gather facts using `setup` module if needed

---

## 6. Difference between `set_fact` and registered variables

### Answer:

| Feature     | set_fact    | register   |
| ----------- | ----------- | ---------- |
| Persistence | Entire play | Task only  |
| Scope       | Host-level  | Task-level |
| Dynamic     | Yes         | No         |

---

## 7. How does Ansible Vault work internally?

### Answer:

* Uses **AES-256 encryption**
* Encrypts files or variables
* Decrypted in-memory during runtime
* Never written back in plain text

---

## 8. Explain handler execution in complex scenarios

### Answer:

* Handlers run **only if notified**
* Run at the **end of a play**
* `meta: flush_handlers` forces immediate execution
* Each handler runs **once per play**, even if notified multiple times

---

## 9. Difference between `delegate_to` and `local_action`

### Answer:

| Feature     | delegate_to | local_action   |
| ----------- | ----------- | -------------- |
| Scope       | Any host    | localhost only |
| Flexibility | High        | Limited        |

---

## 10. How do roles differ from playbooks?

### Answer:

Roles provide:

* Standard directory structure
* Reusability
* Better dependency management
* Scalability

Playbooks orchestrate roles.

---

## 11. Explain Ansible execution strategy

### Answer:

* `linear` (default): lockstep execution
* `free`: hosts run independently
* `host_pinned`: reduces context switching

---

## 12. What is `changed_when` and `failed_when`?

### Answer:

Used to **override module result logic**.

Example:

```yaml
changed_when: false
failed_when: result.rc != 0
```

---

## 13. How does Ansible ensure consistency without agents?

### Answer:

* Push-based model
* Uses SSH
* Stateless execution
* Desired-state enforcement

---

## 14. How do you debug a failing Ansible playbook?

### Answer:

* `-vvv` or `-vvvv`
* `debug` module
* `check_mode`
* `diff`
* `ansible-playbook --step`

---

## 15. Explain inventory precedence order

### Answer (Highest → Lowest):

1. Extra vars
2. Task vars
3. Block vars
4. Role vars
5. Play vars
6. Inventory vars
7. Facts

---

## 16. Difference between static and dynamic inventory

### Answer:

| Static   | Dynamic         |
| -------- | --------------- |
| INI/YAML | Script / Plugin |
| Manual   | Cloud-based     |

---

## 17. What is `check mode` and its limitations?

### Answer:

* Simulates changes
* Does not execute commands
* Not supported by all modules

---

## 18. Can Ansible be used for orchestration?

### Answer:

Yes, but:

* Not event-driven
* Slower than Kubernetes
* Best for infra and config orchestration

---

## 19. Difference between `template`, `copy`, and `lineinfile`

### Answer:

| Module     | Purpose           |
| ---------- | ----------------- |
| template   | Dynamic files     |
| copy       | Static files      |
| lineinfile | Single-line edits |

---

## 20. Hardest Scenario Question

### Question:

How do you safely update SSH port across 1000 servers without losing access?

### Answer:

* Use `serial`
* Use `wait_for`
* Modify config
* Restart SSH
* Validate connectivity before next batch

---

## One-Line Interview Killer Summary

> **Ansible is an agentless, idempotent, push-based automation tool designed for predictable infrastructure management.**

---

## Final Tip

If you can answer **all questions in this document confidently**, you are **senior-level Ansible ready**.

---

## 21. Explain Ansible variable precedence with a real scenario

### Answer:

Ansible resolves variables using a **strict precedence order**. In real scenarios, unexpected values usually come from `extra-vars` overriding everything.

Real scenario:

* Inventory sets `env=dev`
* Role defaults set `env=test`
* Extra vars set `env=prod`

➡ Final value: `prod`

---

## 22. What is the difference between role defaults and vars?

### Answer:

| Aspect   | defaults | vars |
| -------- | -------- | ---- |
| Priority | Lowest   | High |
| Override | Easy     | Hard |

Defaults are meant to be overridden; vars are not.

---

## 23. How do you handle secrets without Ansible Vault?

### Answer:

* Environment variables
* External secret managers (AWS Secrets Manager, HashiCorp Vault)
* CI/CD injected secrets

Vault is recommended but not the only option.

---

## 24. Explain `run_once` with a real use case

### Answer:

`run_once` ensures a task runs **only on one host**, even when targeting multiple hosts.

Use case:

* Database schema migration
* Generating shared artifacts

---

## 25. What is `any_errors_fatal`?

### Answer:

If one host fails, **all hosts stop execution immediately**.

Used in critical operations like cluster upgrades.

---

## 26. How do you control rolling deployments in Ansible?

### Answer:

* `serial`
* Health checks (`wait_for`)
* Handlers

This ensures zero downtime deployments.

---

## 27. Difference between `vars_files` and `include_vars`

### Answer:

| vars_files | include_vars |
| ---------- | ------------ |
| Static     | Dynamic      |
| Parse time | Runtime      |

---

## 28. What is `hostvars` and when is it dangerous?

### Answer:

`hostvars` allows access to variables of other hosts.

Danger:

* Breaks isolation
* Can cause race conditions

---

## 29. Explain `strategy: free` with drawbacks

### Answer:

Allows hosts to run tasks independently.

Drawbacks:

* Harder debugging
* Unsafe for ordered operations

---

## 30. Hard Scenario Question

### Question:

How would you upgrade Kubernetes nodes using Ansible without downtime?

### Answer:

* Use `serial`
* Drain node
* Upgrade
* Uncordon
* Validate

---

## 31. How does Ansible handle failures internally?

### Answer:

* Stops task on failed host
* Continues on others (default)
* Controlled via `ignore_errors`, `max_fail_percentage`

---

## 32. What is `max_fail_percentage`?

### Answer:

Stops play execution if failures exceed a defined percentage.

---

## 33. Explain `until`, `retries`, and `delay`

### Answer:

Used for polling and eventual consistency.

Common in service startup validation.

---

## 34. Can Ansible manage Windows at scale?

### Answer:

Yes, using WinRM and Windows modules, but with slower execution compared to Linux.

---

## 35. What is the biggest limitation of Ansible?

### Answer:

* No real event-driven execution
* Slower at very large scale
* YAML complexity in massive playbooks

---

## Final Interview Reality Check

If you can confidently answer **all 35+ questions**, you are **senior-to-architect level Ansible ready**.

---

Happy Interviewing 🚀
