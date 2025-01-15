import { Prisma, PrismaClient } from '@prisma/client';
import { typeid } from 'typeid-js';
import { IdPrefix } from '$lib/models/IdPrefix';

type IdPrefixNames = keyof typeof IdPrefix;

const prefixedIdsExtension = Prisma.defineExtension({
	name: 'Type ID Prefixer',
	// @ts-expect-error - This is a hack to dynamically generate the query object
	query: Object.fromEntries(
		Object.entries(IdPrefix).map(([model, prefix]) => [
			model,
			{
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				async create({ args, query }: { args: any; query: any }) {
					args.data = {
						...args.data,
						id: `${args.data.id ? `${prefix}_${args.data.id}` : typeid(prefix).toString()}`
					};
					return query(args);
				},
				// eslint-disable-next-line @typescript-eslint/no-explicit-any
				async createMany({ args, query }: { args: any; query: any }) {
					if (Array.isArray(args.data)) {
						// eslint-disable-next-line @typescript-eslint/no-explicit-any
						args.data = args.data.map((item: any) => ({
							...item,
							id: `${item.id ? `${prefix}_${item.id}` : typeid(prefix).toString()}`
						}));
					} else {
						args.data = {
							...args.data,
							id: `${args.data.id ? `${prefix}_${args.data.id}` : typeid(prefix).toString()}`
						};
					}
					return query(args);
				}
			}
			// eslint-disable-next-line @typescript-eslint/no-explicit-any
		]) as [IdPrefixNames, any][]
	)
});

export const prisma = new PrismaClient().$extends(prefixedIdsExtension);
