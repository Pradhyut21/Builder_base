BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "counters" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "isPaused" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "counters_name_idx" ON "counters" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "queue_entries" (
    "id" bigserial PRIMARY KEY,
    "counterId" bigint NOT NULL,
    "visitorName" text NOT NULL,
    "phone" text,
    "joinedAt" timestamp without time zone NOT NULL,
    "status" text NOT NULL,
    "calledAt" timestamp without time zone,
    "position" bigint NOT NULL DEFAULT -1,
    "ownerToken" text NOT NULL
);

-- Indexes
CREATE INDEX "queue_entries_counter_id_idx" ON "queue_entries" USING btree ("counterId");
CREATE INDEX "queue_entries_counter_status_idx" ON "queue_entries" USING btree ("counterId", "status");
CREATE INDEX "queue_entries_joined_at_idx" ON "queue_entries" USING btree ("counterId", "joinedAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "staff_users" (
    "id" bigserial PRIMARY KEY,
    "counterId" bigint NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE INDEX "staff_users_counter_id_idx" ON "staff_users" USING btree ("counterId");
CREATE UNIQUE INDEX "staff_users_email_counter_unique" ON "staff_users" USING btree ("email", "counterId");


--
-- MIGRATION VERSION FOR queuesync
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('queuesync', '20260927100359064', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260927100359064', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
