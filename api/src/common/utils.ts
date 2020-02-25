import Table from '../db/table';
import { Identifiable } from '../lib/types';

export function findMaxId(items: Array<Identifiable>): number {
    let maxId = 0;
    for (const item of items) {
        if (item.id > maxId) {
            maxId = item.id;
        }
    }
    return maxId;
}

export async function checkCache<T>(cache: Map<number, T>, id: number, updated: Date, dependencies: Array<Table<any>>): Promise<T | undefined> {
    if (cache.has(id) === false) {
        return undefined;
    }

    const anyRefreshed = await refreshDependencies(updated, dependencies);
    if (anyRefreshed) {
        cache.clear();
    }

    return cache.get(id);
}

export async function refreshDependencies(lastUpdate: Date, dependencies: Array<Table<any>>): Promise<boolean> {
    const promises: Array<Promise<any>> = [];
    for (const dependency of dependencies) {
        if (dependency.anyUpdatesSince(lastUpdate)) {
            promises.push(dependency.refreshData());
        }
    }

    if (promises.length > 0) {
        await Promise.all(promises);
        return true;
    }
    return false;
}

export function apiURL(withScheme: boolean): string {
    const baseURL = process.env.API_URL;
    if (!baseURL) {
        throw Error("API URL could not be determined");
    }

    if (baseURL.startsWith('http')) {
        if (withScheme) {
            return baseURL;
        } else {
            return baseURL.substr(baseURL.indexOf('/') + 2);
        }
    } else {
        if (withScheme) {
            if (process.env.SSL_ENABLED) {
                return `https://${baseURL}`;
            } else {
                return `http://${baseURL}`;
            }
        } else {
            return baseURL;
        }
    }
}
