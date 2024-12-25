CREATE TABLE "accounts" (
  "id" bigserial PRIMARY KEY,
  "owner" varchar(255) NOT NULL,
  "balance" bigint NOT NULL,
  "currency" varchar(32) NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "entries" (
  "id" bigserial PRIMARY KEY,
  "accountId" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "transfers" (
  "id" bigserial PRIMARY KEY,
  "fromAccountId" bigint NOT NULL,
  "toAccountId" bigint NOT NULL,
  "amount" bigint NOT NULL,
  "createdAt" timestamptz NOT NULL DEFAULT (now())
);

CREATE INDEX ON "accounts" ("owner");

CREATE INDEX ON "entries" ("accountId");

CREATE INDEX ON "transfers" ("fromAccountId");

CREATE INDEX ON "transfers" ("toAccountId");

CREATE INDEX ON "transfers" ("fromAccountId", "toAccountId");

COMMENT ON COLUMN "entries"."amount" IS '+ve / -ve';

COMMENT ON TABLE "transfers" IS 'Enforce positive amounts using a CHECK constraint in the SQL layer: CHECK (amount > 0).';

COMMENT ON COLUMN "transfers"."amount" IS '+ve only';

ALTER TABLE "entries" ADD FOREIGN KEY ("accountId") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("fromAccountId") REFERENCES "accounts" ("id");

ALTER TABLE "transfers" ADD FOREIGN KEY ("toAccountId") REFERENCES "accounts" ("id");
