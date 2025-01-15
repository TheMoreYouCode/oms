/*
  Warnings:

  - You are about to drop the `BusinessContacts` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "BusinessContacts" DROP CONSTRAINT "BusinessContacts_businessId_fkey";

-- DropForeignKey
ALTER TABLE "BusinessContacts" DROP CONSTRAINT "BusinessContacts_contactId_fkey";

-- DropTable
DROP TABLE "BusinessContacts";

-- CreateTable
CREATE TABLE "BusinessContact" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "role" "RoleType" NOT NULL,
    "default" BOOLEAN NOT NULL DEFAULT false,
    "phone" TEXT,
    "mobile" TEXT,
    "department" TEXT,
    "businessId" TEXT NOT NULL,
    "contactId" TEXT NOT NULL,

    CONSTRAINT "BusinessContact_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "BusinessContact_businessId_contactId_key" ON "BusinessContact"("businessId", "contactId");

-- AddForeignKey
ALTER TABLE "BusinessContact" ADD CONSTRAINT "BusinessContact_businessId_fkey" FOREIGN KEY ("businessId") REFERENCES "Business"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BusinessContact" ADD CONSTRAINT "BusinessContact_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES "Contact"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
