# Product Requirements Document

> _AI-generated via LiteLLM (prd.md) — **unverified** until approved._

## 1. Document Summary and Product Vision

**Product:** Branch-tablet account onboarding, release **v2.4.1** (target date **2026-11-19**, [TC01_fds_retail_onboarding.md]).
**Scope of this release:** Premium Savings onboarding on the branch tablet, plus credit card linking to the savings account.
**Vision:** Branch officers open Premium Savings accounts on the tablet faster and with fewer errors than the manual process. Identity is verified through PhilSys, with a recorded manual fallback. Applications survive connectivity loss.

**Source conventions**
- Facts from the FDS carry [TC01_fds_retail_onboarding.md]. Facts from the TDS carry [TC01_tds_account_service.md]. Facts from approved discovery answers carry no label.
- `Assumption:` marks model-introduced content. `TBD:` marks a gap that needs an owner decision.
- **Identifier note:** The FDS traces upstream requirements "FR-1023 to FR-1031" from ticket ADO-4821, but their text is not supplied. This PRD uses its own FR-001+ identifiers. "FR-1027" appears only as the TDS **error code** for an already-linked card, and it is not a PRD requirement ID.
- **Omitted section:** Section 10 (UX and Accessibility) is omitted because no source states UX or accessibility requirements. UX-relevant behavior appears in FR-012 and the journeys in section 5.

## 2. Problem Statement and Opportunity

- **Problem:** Manual onboarding at branches is slow and error-prone (discovery).
- **Opportunity:** A tablet flow with automated identity verification, validation, and draft resilience reduces time per application and rework. The FDS describes the tablet flow [TC01_fds_retail_onboarding.md].
- **Urgency:** Implied by the v2.4.1 release date of 2026-11-19 [TC01_fds_retail_onboarding.md].
- Assumption: the baseline for "slow" is not quantified in any source. See OQ-01.

## 3. Primary Users, Stakeholders, and User Needs

| ID | User / Stakeholder | Need | Source |
|---|---|---|---|
| UN-01 | Branch officer (primary, operates the tablet) | Complete a Premium Savings application quickly and correctly | Discovery |
| UN-02 | Branch officer | Verify identity even when the PhilSys check fails, and record the outcome | Discovery; [TC01_fds_retail_onboarding.md] |
| UN-03 | Branch officer | Not lose an in-progress application when Core Banking or tablet connectivity drops | Discovery |
| UN-04 | Branch officer | Link a credit card to the new account and get a clear error if it is already linked | [TC01_tds_account_service.md] |
| UN-05 | Customer | Open a Premium Savings account, with OTP confirmation and call-back when needed | [TC01_fds_retail_onboarding.md] |
| UN-06 | Onboarding team lead | Receive escalations for failed checks | [TC01_fds_retail_onboarding.md] |
| UN-07 | Second approver | Approve amounts that exceed the stated threshold | [TC01_tds_account_service.md] |

The team lead named in the FDS is [PII_PERSON_bf5612b2489414c346daab8ab68da4ba], contactable at [PII_EMAIL_24d975a01099114cf9861e108b2775c6] [TC01_fds_retail_onboarding.md].

## 4. Goals, Success Metrics, and Non-Goals

| ID | Goal | Metric / Target |
|---|---|---|
| G-01 | Shorter time to open an account per application (primary success outcome) | M-01: Relative reduction (e.g. 30%) vs a baseline measured before release. TBD: exact target % (OQ-01). |
| G-02 | Reliable identity verification | M-02: 100% of applications have a recorded PhilSys outcome (pass, or fail with call-back outcome). Assumption: target is introduced here. |
| G-03 | No lost applications on connectivity loss | M-03: 100% of interrupted applications are resumable as the same application. Assumption: target is introduced here. |
| G-04 | Card linking works with clear errors | M-04: 100% of already-linked attempts return error code FR-1027 [TC01_tds_account_service.md]. |

**Non-goals (v2.4.1):** Savings products other than Premium Savings. Any capability beyond tablet onboarding and card linking. The ranking of speed against accuracy and controls is not defined (OQ-05).

## 5. User Personas and User Journeys

**Personas:** Branch officer (primary), customer, onboarding team lead, second approver (see section 3).

**Journeys.** The end-to-end happy-path sequence is not stated in the sources (known gap), so only the stated paths are described. Assumption: the happy path follows the order of FR-001 to FR-008, and this must be confirmed (OQ-02).

| ID | Journey | Steps | Requirements |
|---|---|---|---|
| J-01 | PhilSys failure | PhilSys check fails → officer calls the customer → outcome recorded → escalation to the team lead if needed | FR-003, FR-004, FR-005 |
| J-02 | Connectivity lost mid-application | Connectivity drops → draft auto-saved → connectivity returns → officer resumes the same application | FR-012 |
| J-03 | Card already linked | Officer submits link-card → error code FR-1027 returned | FR-009, FR-011 |
| J-04 | High-value approval | Amount above PHP 125,000.00 → second approver required (subject of the rule is unclear, OQ-04) | FR-008 |

## 6. Release Scope and Priorities

Priority scale: **P0** = release-blocking, **P1** = required for v2.4.1, **P2** = desirable.

| In scope v2.4.1 | Requirements |
|---|---|
| Premium Savings branch-tablet onboarding | FR-001, FR-002, FR-006, FR-007, FR-008, FR-013, FR-014 |
| PhilSys check with call-back fallback and recorded outcome (P0, release-blocking per discovery) | FR-003, FR-004, FR-005 |
| Connectivity-loss draft resume | FR-012 |
| Credit card linking | FR-009, FR-010, FR-011 |
| Outgoing SWIFT identifier | FR-015 |
| Success measurement | FR-016 |

Out of scope: the non-goals in section 4. Rollout, branch phasing, training, and feature-flag plans are not stated (OQ-07).

## 7. Functional Requirements

### 7.1 Requirements

| ID | Priority | Requirement | Acceptance notes | Source |
|---|---|---|---|---|
| FR-001 | P1 | The tablet captures a Premium Savings application with the customer record fields: customer name, mobile, additional contact and email entries, TIN, SSS number, PhilSys number, savings account, credit card, and home address. | All listed fields can be entered and stored. Field-level formats and mandatory flags are TBD (OQ-08). | [TC01_fds_retail_onboarding.md] |
| FR-002 | P1 | The system enforces the minimum opening balance of PHP 125,000.00 for Premium Savings (BR-001). | A balance below the minimum is rejected. The message text is TBD (OQ-08). | [TC01_fds_retail_onboarding.md] |
| FR-003 | P0 | The system performs a PhilSys identity check during onboarding. | The result (pass or fail) is obtained and stored with the application. Interface details are TBD (OQ-06). | Discovery; [TC01_fds_retail_onboarding.md] |
| FR-004 | P0 | On PhilSys failure, the officer follows a manual call-back to the customer and records the outcome (BR-008). | The application cannot complete without a recorded outcome. Assumption: the gating behavior is introduced here. | [TC01_fds_retail_onboarding.md] |
| FR-005 | P1 | Escalations from failed checks go to the onboarding team lead (BR-009). | The escalation contact is available to the officer. | [TC01_fds_retail_onboarding.md] |
| FR-006 | P1 | A one-time password is valid for 300 seconds (BR-005). | An OTP older than 300 s is rejected. Assumption: OTP is used to confirm the customer during onboarding, because the sources do not state where it applies (OQ-03). | [TC01_fds_retail_onboarding.md] |
| FR-007 | P1 | The system applies the daily limit of 50000 (BR-006). | The limit is enforced. The unit and scope of the limit are TBD (OQ-03). | [TC01_fds_retail_onboarding.md] |
| FR-008 | P1 | A second approver is required for amounts above PHP 125,000.00 (BR-011). | The approval is captured before completion. The rule's exact subject is TBD (OQ-04). | [TC01_tds_account_service.md] |
| FR-009 | P1 | `POST /accounts/v1/link-card` links a credit card to a savings account. | A valid request links the card. The request carries accountNumber, cardNumber, holderName, holderTin, holderEmail, and mailingAddress. | [TC01_tds_account_service.md] |
| FR-010 | P1 | The link-card service validates that `accountNumber` is 13 digits (BR-010). | A non-13-digit value is rejected. The error message text is TBD. | [TC01_tds_account_service.md] |
| FR-011 | P1 | The link-card service returns error code FR-1027 when the card is already linked (BR-012). | An already-linked card returns FR-1027. The officer sees an understandable message (text TBD). | [TC01_tds_account_service.md] |
| FR-012 | P1 | When Core Banking or tablet connectivity is lost mid-application, the draft is auto-saved and the officer resumes the same application once connectivity returns (BR-013). | No entered data is lost. Resume reopens the same application, not a new one. | Discovery |
| FR-013 | P1 | Each branch is identified by its branch code (e.g. 0457) on applications (BR-003). | The branch code is attached to each application. | [TC01_fds_retail_onboarding.md] |
| FR-014 | P1 | Applications at Metro Manila branches are processed on the same business day (BR-002). | Submitted applications are processed by end of the same business day. | [TC01_fds_retail_onboarding.md] |
| FR-015 | P2 | Outgoing SWIFT messages use bank identifier MBTCPHMM (BR-004). | Outbound messages carry MBTCPHMM. The trigger within onboarding is TBD (OQ-06). | [TC01_fds_retail_onboarding.md] |
| FR-016 | P1 | The system records timestamps sufficient to measure time to open an account per application, for comparison with the pre-release baseline. | Start and completion times are available per application. Assumption: this requirement is introduced to support M-01. | Discovery |

### 7.2 Business Rules

| ID | Condition | Outcome | Source |
|---|---|---|---|
| BR-001 | Product is Premium Savings | Minimum opening balance is PHP 125,000.00. The rejection message is TBD. | [TC01_fds_retail_onboarding.md] |
| BR-002 | Branch is in Metro Manila | Applications are processed on the same business day. | [TC01_fds_retail_onboarding.md] |
| BR-003 | Any branch | The branch is identified by its branch code (example: 0457). | [TC01_fds_retail_onboarding.md] |
| BR-004 | Outgoing SWIFT message | Bank identifier is MBTCPHMM. | [TC01_fds_retail_onboarding.md] |
| BR-005 | OTP issued | Valid for 300 seconds. | [TC01_fds_retail_onboarding.md] |
| BR-006 | Daily limit applies | Limit is 50000. The unit and scope are not stated. | [TC01_fds_retail_onboarding.md] |
| BR-007 | Release | Target version is v2.4.1, scheduled for 2026-11-19. | [TC01_fds_retail_onboarding.md] |
| BR-008 | PhilSys check fails | The branch officer calls the customer on [PII_PHONE_e19d301dfddb8f98e8472ed6e9a0e1f1] and records the outcome. | [TC01_fds_retail_onboarding.md] |
| BR-009 | Escalation needed | Goes to the onboarding team lead, [PII_PERSON_bf5612b2489414c346daab8ab68da4ba], at [PII_EMAIL_24d975a01099114cf9861e108b2775c6]. | [TC01_fds_retail_onboarding.md] |
| BR-010 | Link-card request | `accountNumber` must be 13 digits. | [TC01_tds_account_service.md] |
| BR-011 | Amount above PHP 125,000.00 | A second approver is required. The source line is garbled: "the formatted display pattern is [PII_PERSON_07d819c7bf13ff22e1a7498710a811dd] above PHP 125,000.00 require a second approver". The subject (for example, which amounts) is TBD, and the account-number display pattern is not recoverable. | [TC01_tds_account_service.md] |
| BR-012 | Card is already linked | Error code FR-1027 is returned. | [TC01_tds_account_service.md] |
| BR-013 | Core Banking or tablet connectivity lost mid-application | The draft is auto-saved. The officer resumes the same application when connectivity returns. | Discovery |
| BR-014 | Success measurement | Time to open an account is targeted as a relative reduction (e.g. 30%) against a pre-release baseline. | Discovery |

## 8. Non-Functional Requirements

The sources state no performance, availability, or accessibility targets (known gap). Targets below are marked as source-stated or Assumption.

| ID | Requirement | Measurable target | Basis |
|---|---|---|---|
| NFR-001 | OTP validity | 300 seconds | [TC01_fds_retail_onboarding.md] |
| NFR-002 | Time to open an account | Relative reduction vs pre-release baseline. Target % is TBD (e.g. 30%). | Discovery |
| NFR-003 | Draft durability | 0 data fields lost on connectivity interruption in test. | Assumption |
| NFR-004 | Same-day processing | 100% of Metro Manila applications processed the same business day. | [TC01_fds_retail_onboarding.md] |
| NFR-005 | Availability and response-time targets | TBD: owner to set (OQ-09). | Gap |
| NFR-006 | Security and regulatory compliance | TBD: applicable regulations are not stated (OQ-10). Source-stated controls: OTP and second approver. Sensitive IDs (TIN, SSS, PhilSys) are captured. | Gap |

## 9. Data, Integrations, and External Interfaces

| Item | Detail | Source |
|---|---|---|
| Core Banking integration layer | Hosts the Account Service, versioned v2.4.1. | [TC01_tds_account_service.md] |
| `POST /accounts/v1/link-card` | Links a credit card to a savings account. Request fields: accountNumber, cardNumber, holderName, holderTin, holderEmail, mailingAddress. Error code FR-1027 if the card is already linked. | [TC01_tds_account_service.md] |
| PhilSys check | External identity verification. Ownership and interface are unclear (OQ-06). | [TC01_fds_retail_onboarding.md] |
| SWIFT | Outgoing messages use MBTCPHMM. | [TC01_fds_retail_onboarding.md] |
| Sensitive data captured | Customer name, contact details, TIN, SSS number, PhilSys number, account and card numbers, home address. | [TC01_fds_retail_onboarding.md] |
| Production support | Incidents go to the service desk on [PII_PHONE_ade65b7c5c39028ec4ebe53cc4d57070]. | [TC01_tds_account_service.md] |

## 11. Analytics and Observability Requirements

- Per-application start and completion timestamps support M-01 (FR-016).
- Record the PhilSys outcome (pass, or fail with call-back outcome) to support M-02 (FR-003, FR-004). Assumption: reporting of these outcomes is introduced here.
- Record the count of drafts auto-saved and resumed to support M-03 (FR-012). Assumption: this is introduced here.
- Count FR-1027 errors to support M-04.
- TBD: dashboards, alerting, and logging standards are not stated in any source.

## 12. Dependencies and Constraints

- Release v2.4.1 on 2026-11-19 [TC01_fds_retail_onboarding.md].
- Dependencies: the Core Banking integration layer, the PhilSys check, and SWIFT (ownership TBD). Tablet and Core Banking connectivity is a flagged risk.
- Constraints: PHP 125,000.00 minimum balance, 300 s OTP, and daily limit of 50000 (BR-001, BR-005, BR-006).
- No library, framework, or runtime versions are stated in the sources, so none are specified. Technology choices belong to the Architecture step.
- The pre-release baseline measurement must be completed before release to evaluate M-01.

## 13. Risks and Mitigations

| ID | Risk | Mitigation |
|---|---|---|
| R-01 | Core Banking or tablet connectivity loss mid-application (flagged risk) | FR-012 draft auto-save and resume. Test NFR-003. |
| R-02 | PhilSys check failure blocks onboarding | FR-004 call-back fallback with recorded outcome. FR-005 escalation. |
| R-03 | The success target is undefined, so the outcome cannot be evaluated | Fix the target % and baseline method before release (OQ-01). |
| R-04 | Ambiguous rules (BR-006 and BR-011) cause incorrect enforcement | Resolve OQ-03 and OQ-04 before build. |
| R-05 | Regulatory obligations for sensitive IDs are unknown | Resolve OQ-10 with compliance. |
| R-06 | Rollout and training are unplanned for the 2026-11-19 date | Define the rollout plan (OQ-07). |

## 14. Open Questions

| ID | Question |
|---|---|
| OQ-01 | What is the exact reduction target (e.g. 30%) and how is the baseline measured? |
| OQ-02 | What is the end-to-end happy-path sequence? |
| OQ-03 | Where does the OTP apply? What are the unit and scope of the daily limit of 50000? |
| OQ-04 | What does the garbled TDS rule cover (second approver above PHP 125,000.00)? What is the account-number display pattern? |
| OQ-05 | How are speed, accuracy, and controls ranked when they conflict? |
| OQ-06 | Who owns the PhilSys, Core Banking, and SWIFT interfaces, and what are their contracts? |
| OQ-07 | What are the branch rollout, training, and feature-flag plans? |
| OQ-08 | What are the field formats, mandatory flags, and error message texts? |
| OQ-09 | What are the performance, availability, and accessibility targets? |
| OQ-10 | Which regulatory and security obligations apply? |

## 15. Requirements Traceability

| Requirement | Goal | User need | Evidence |
|---|---|---|---|
| FR-001 | G-01 | UN-01, UN-05 | [TC01_fds_retail_onboarding.md] |
| FR-002 | G-01 | UN-05 | [TC01_fds_retail_onboarding.md] |
| FR-003 | G-02 | UN-02 | Discovery; [TC01_fds_retail_onboarding.md] |
| FR-004 | G-02 | UN-02 | [TC01_fds_retail_onboarding.md] |
| FR-005 | G-02 | UN-06 | [TC01_fds_retail_onboarding.md] |
| FR-006 | G-01 | UN-05 | [TC01_fds_retail_onboarding.md] |
| FR-007 | G-01 | UN-01 | [TC01_fds_retail_onboarding.md] |
| FR-008 | G-02 | UN-07 | [TC01_tds_account_service.md] |
| FR-009 | G-04 | UN-04 | [TC01_tds_account_service.md] |
| FR-010 | G-04 | UN-04 | [TC01_tds_account_service.md] |
| FR-011 | G-04 | UN-04 | [TC01_tds_account_service.md] |
| FR-012 | G-03 | UN-03 | Discovery |
| FR-013 | G-01 | UN-01 | [TC01_fds_retail_onboarding.md] |
| FR-014 | G-01 | UN-05 | [TC01_fds_retail_onboarding.md] |
| FR-015 | G-01 | UN-01 | [TC01_fds_retail_onboarding.md] |
| FR-016 | G-01 | UN-01 | Discovery |

| NFR | Related requirements |
|---|---|
| NFR-001 | FR-006 |
| NFR-002 | FR-016 |
| NFR-003 | FR-012 |
| NFR-004 | FR-014 |
| NFR-005, NFR-006 | All (targets TBD) |
