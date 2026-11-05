<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use RuntimeException;

/**
 * Imports the data (INSERT statements) from database/seeders/sql/ai_erp_lvl.sql.
 * Existing rows in the imported tables are truncated first.
 */
class AiErpLvlDumpSeeder extends Seeder
{
    /** Framework/runtime tables that should not be restored. */
    private const SKIP_TABLES = ['cache', 'cache_locks', 'sessions', 'migrations', 'jobs', 'failed_jobs'];

    public function run(): void
    {
        $path = database_path('seeders/sql/ai_erp_lvl.sql');
        $sql = file_get_contents($path);

        if ($sql === false) {
            throw new RuntimeException('Unable to read the database dump.');
        }

        preg_match_all('/^INSERT INTO `(\w+)`.*?\);[ \t]*$/ms', $sql, $matches, PREG_SET_ORDER);

        $statements = [];
        foreach ($matches as [$statement, $table]) {
            if (! in_array($table, self::SKIP_TABLES, true) && Schema::hasTable($table)) {
                $statements[$table][] = $statement;
            }
        }

        Schema::disableForeignKeyConstraints();

        try {
            foreach ($statements as $table => $inserts) {
                DB::table($table)->truncate();

                foreach ($inserts as $insert) {
                    /** @var literal-string $insert */
                    DB::unprepared($insert);
                }
            }
        } finally {
            Schema::enableForeignKeyConstraints();
        }
    }
}
