-- CreateEnum
CREATE TYPE "UserGender" AS ENUM ('Male', 'Female');

-- CreateEnum
CREATE TYPE "Typetransaction" AS ENUM ('income', 'expense');

-- CreateTable
CREATE TABLE "User" (
    "oidcId" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "gender" "UserGender",
    "date" TIMESTAMP(3),
    "email" TEXT,
    "tel" TEXT,
    "picture" TEXT,
    "password" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("oidcId")
);

-- CreateTable
CREATE TABLE "Category" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "transaction_id" TEXT NOT NULL,
    "user_id" TEXT,
    "category_id" TEXT,
    "amount" DOUBLE PRECISION NOT NULL,
    "date" TIMESTAMP(3),
    "description" TEXT,
    "type" "Typetransaction" NOT NULL DEFAULT 'expense',

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("transaction_id")
);

-- CreateTable
CREATE TABLE "Budget" (
    "budget_id" TEXT NOT NULL,
    "user_id" TEXT,
    "category_id" TEXT,
    "amount" DOUBLE PRECISION,
    "month" TIMESTAMP(3),
    "alert_threshold" INTEGER,

    CONSTRAINT "Budget_pkey" PRIMARY KEY ("budget_id")
);

-- CreateTable
CREATE TABLE "Report" (
    "report_id" TEXT NOT NULL,
    "user_id" TEXT,
    "created_at" TEXT,
    "file_path" TEXT,

    CONSTRAINT "Report_pkey" PRIMARY KEY ("report_id")
);

-- CreateTable
CREATE TABLE "OtpVerification" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "email" TEXT,
    "otp" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OtpVerification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserDevice" (
    "userId" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "ua" JSONB,

    CONSTRAINT "UserDevice_pkey" PRIMARY KEY ("userId","token")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_oidcId_key" ON "User"("oidcId");

-- CreateIndex
CREATE UNIQUE INDEX "Category_id_key" ON "Category"("id");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_transaction_id_key" ON "Transaction"("transaction_id");

-- CreateIndex
CREATE UNIQUE INDEX "Budget_budget_id_key" ON "Budget"("budget_id");

-- CreateIndex
CREATE UNIQUE INDEX "Report_report_id_key" ON "Report"("report_id");

-- CreateIndex
CREATE INDEX "OtpVerification_user_id_idx" ON "OtpVerification"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "UserDevice_token_key" ON "UserDevice"("token");

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("oidcId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Budget" ADD CONSTRAINT "Budget_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("oidcId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Budget" ADD CONSTRAINT "Budget_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Report" ADD CONSTRAINT "Report_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("oidcId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OtpVerification" ADD CONSTRAINT "OtpVerification_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("oidcId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserDevice" ADD CONSTRAINT "UserDevice_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("oidcId") ON DELETE RESTRICT ON UPDATE CASCADE;
