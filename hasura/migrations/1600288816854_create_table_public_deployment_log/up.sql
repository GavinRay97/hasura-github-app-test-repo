CREATE TABLE "public"."deployment_log"("id" serial NOT NULL, "created_at" timestamptz NOT NULL DEFAULT now(), "updated_at" timestamptz NOT NULL DEFAULT now(), "github_repo_id" integer NOT NULL, "stdout" text NOT NULL, "stderr" text, PRIMARY KEY ("id") , FOREIGN KEY ("github_repo_id") REFERENCES "public"."github_repo"("id") ON UPDATE restrict ON DELETE restrict);
CREATE OR REPLACE FUNCTION "public"."set_current_timestamp_updated_at"()
RETURNS TRIGGER AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER "set_public_deployment_log_updated_at"
BEFORE UPDATE ON "public"."deployment_log"
FOR EACH ROW
EXECUTE PROCEDURE "public"."set_current_timestamp_updated_at"();
COMMENT ON TRIGGER "set_public_deployment_log_updated_at" ON "public"."deployment_log" 
IS 'trigger to set value of column "updated_at" to current timestamp on row update';
