# ---- Dependencies ----
FROM node:20-alpine AS deps
WORKDIR /app
# Prisma uchun kerakli kutubxonalar
RUN apk add --no-cache libc6-compat openssl
COPY package.json package-lock.json* ./
COPY prisma ./prisma
RUN npm ci

# ---- Builder ----
FROM node:20-alpine AS builder
WORKDIR /app
RUN apk add --no-cache libc6-compat openssl
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# Prisma client generatsiyasi va Next build (standalone)
RUN npx prisma generate
RUN npm run build

# ---- Runner ----
FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=5000
ENV HOSTNAME=0.0.0.0
RUN apk add --no-cache openssl

RUN addgroup --system --gid 1001 nodejs \
  && adduser --system --uid 1001 nextjs

# Standalone server fayllari
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Prisma CLI va schema (migratsiya/db push uchun)
COPY --from=builder /app/node_modules/.prisma ./node_modules/.prisma
COPY --from=builder /app/node_modules/@prisma ./node_modules/@prisma
COPY --from=builder /app/node_modules/prisma ./node_modules/prisma
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/docker-entrypoint.sh ./docker-entrypoint.sh

# Yuklanadigan fayllar va QR rasmlar uchun papkalar
RUN mkdir -p ./public/uploads ./public/qr \
  && chown -R nextjs:nodejs ./public \
  && chmod +x ./docker-entrypoint.sh

USER nextjs
EXPOSE 5000

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["node", "server.js"]
