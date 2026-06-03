# Flux-Debug Skill Evaluation - Iteration 1

## Benchmark Results

### Summary

| Configuration | Pass Rate | Avg Tokens | Avg Duration |
|---------------|-----------|------------|--------------|
| **With Skill** | **100%** | 8,497 | 18.4s |
| Without Skill | 42% | 5,281 | 11.1s |
| **Improvement** | **+58%** | +3,216 | +7.3s |

### Per-Eval Breakdown

#### Eval 0: gitrepository-not-ready
| Configuration | Pass Rate | Commands |
|---------------|-----------|----------|
| With Skill | 100% | kubectl describe, flux logs, ssh -T, Secret-check |
| Without Skill | 25% | kubectl describe (endast) |

#### Eval 1: helmrelease-artifact-failed
| Configuration | Pass Rate | Commands |
|---------------|-----------|----------|
| With Skill | 100% | kubectl describe, helm-controller logs, source verify |
| Without Skill | 67% | kubectl describe, helm-controller logs |

#### Eval 2: kustomization-dependency-not-ready
| Configuration | Pass Rate | Commands |
|---------------|-----------|----------|
| With Skill | 100% | flux tree, flux get sources, flux reconcile |
| Without Skill | 33% | kubectl get (generisk) |

## Key Observations

1. **med-skill-versionen ger mer kompletta svar** - den nämner SSH-verifiering och Secret-hantering som baseline missar

2. **flux tree-kommandot är unikt för skillen** - utan skillen försöker modellen generiska kubectl-kommandon istället för Flux-specifika verktyg

3. **med-skill-versionen är mer strukturerad** - tydliga steg och förklaringar, inte bara kommandon

## Files

- `evals/evals.json` - Test case definitions
- `eval-0/` - gitrepository-not-ready test
- `eval-1/` - helmrelease-artifact-failed test
- `eval-2/` - kustomization-dependency-not-ready test