
import { defineConfig } from "@mikro-orm/core";
import { PostgreSqlDriver } from "@mikro-orm/postgresql";
import { TsMorphMetadataProvider } from "@mikro-orm/reflection";
import { EntityManager } from "@mikro-orm/sql";

export const DatabaseConfig: Parameters<typeof defineConfig<PostgreSqlDriver, EntityManager<PostgreSqlDriver>, string[]>>[0] = {

    // extensions: [SeedManager],

    entities: [
        'dist/database/entities/*.entity.js',
    ],
    // entitiesTs: [
    //     'src/database/entities/*.entity.ts',
    // ],
    migrations: {
        path: 'src/database/migrations',
    },
    driver: PostgreSqlDriver,
    metadataProvider: TsMorphMetadataProvider,
    preferTs: true,
    verbose: true,
    user: process.env.DB_USER || "postgres",
    password: process.env.DB_PASSWORD || "postgres",
    dbName: process.env.DB_NAME || "nitr",
    host: process.env.DB_HOST || "localhost",
    port: process.env.DB_PORT ? parseInt(process.env.DB_PORT) : 5432,
    // debug: process.env.DEBUG === "true" || process.env.DB_DEBUG === "true",
    debug: true,

    seeder: {
        path: "dist/database/seeders",
        pathTs: "src/database/seeders",
        defaultSeeder: "DatabaseSeeder",
        glob: "!(*.d).{js,ts}",
        emit: "ts",
        fileName: (className: string) => className
    }

}