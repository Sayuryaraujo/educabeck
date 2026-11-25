-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateEnum
CREATE TYPE "TipoUsuario" AS ENUM ('USUARIO', 'ADMIN');

-- CreateEnum
CREATE TYPE "Plano" AS ENUM ('FREE', 'PREMIUM');

-- CreateEnum
CREATE TYPE "StatusAssinatura" AS ENUM ('ATIVA', 'EXPIRADA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "TipoMovimentacao" AS ENUM ('RECEITA', 'DESPESA');

-- CreateTable
CREATE TABLE "usuarios" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "telefone" VARCHAR(20),
    "email" VARCHAR(150) NOT NULL,
    "senha" VARCHAR(255),
    "tipo" "TipoUsuario" DEFAULT 'USUARIO',
    "plano" "Plano" DEFAULT 'FREE',
    "status" BOOLEAN DEFAULT true,
    "criado_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "assinaturas" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "plano" "Plano" NOT NULL,
    "status" "StatusAssinatura" DEFAULT 'ATIVA',
    "inicio" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,
    "fim" TIMESTAMP(3),

    CONSTRAINT "assinaturas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cursos" (
    "id" SERIAL NOT NULL,
    "titulo" VARCHAR(150) NOT NULL,
    "descricao" TEXT,
    "conteudo" TEXT,
    "exclusivo" BOOLEAN DEFAULT false,
    "criado_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cursos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "progresso_cursos" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "curso_id" INTEGER NOT NULL,
    "progresso" DECIMAL(5,2) DEFAULT 0.00,
    "concluido" BOOLEAN DEFAULT false,

    CONSTRAINT "progresso_cursos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "quizzes" (
    "id" SERIAL NOT NULL,
    "curso_id" INTEGER,
    "titulo" VARCHAR(150) NOT NULL,
    "descricao" TEXT,
    "exclusivo" BOOLEAN DEFAULT false,

    CONSTRAINT "quizzes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questoes" (
    "id" SERIAL NOT NULL,
    "quiz_id" INTEGER NOT NULL,
    "pergunta" TEXT NOT NULL,
    "resposta_correta" VARCHAR(255) NOT NULL,

    CONSTRAINT "questoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "resultados_quiz" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "quiz_id" INTEGER NOT NULL,
    "pontuacao" DECIMAL(5,2) NOT NULL,
    "realizado_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "resultados_quiz_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "metas" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "nome" VARCHAR(150) NOT NULL,
    "valor_meta" DECIMAL(12,2) NOT NULL,
    "valor_atual" DECIMAL(12,2) DEFAULT 0.00,
    "criada_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "metas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tipos_investimento" (
    "id" SERIAL NOT NULL,
    "nome" VARCHAR(100) NOT NULL,
    "descricao" TEXT,

    CONSTRAINT "tipos_investimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "investimentos" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "tipo_investimento_id" INTEGER NOT NULL,
    "nome" VARCHAR(150) NOT NULL,
    "valor_investido" DECIMAL(12,2) NOT NULL,
    "valor_atual" DECIMAL(12,2) DEFAULT 0.00,
    "rentabilidade" DECIMAL(8,2) DEFAULT 0.00,
    "criado_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "investimentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reservas_emergencia" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "valor" DECIMAL(12,2) DEFAULT 0.00,
    "atualizado_em" TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reservas_emergencia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "movimentacoes" (
    "id" SERIAL NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "tipo" "TipoMovimentacao" NOT NULL,
    "valor" DECIMAL(12,2) NOT NULL,
    "descricao" VARCHAR(255),
    "data_movimentacao" DATE NOT NULL,

    CONSTRAINT "movimentacoes_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "email" ON "usuarios"("email");

-- CreateIndex
CREATE INDEX "idx_assinaturas_usuario_id" ON "assinaturas"("usuario_id");

-- CreateIndex
CREATE INDEX "idx_progresso_cursos_curso_id" ON "progresso_cursos"("curso_id");

-- CreateIndex
CREATE UNIQUE INDEX "uniq_progresso_cursos_usuario_curso" ON "progresso_cursos"("usuario_id", "curso_id");

-- CreateIndex
CREATE INDEX "idx_quizzes_curso_id" ON "quizzes"("curso_id");

-- CreateIndex
CREATE INDEX "idx_questoes_quiz_id" ON "questoes"("quiz_id");

-- CreateIndex
CREATE INDEX "idx_resultados_quiz_quiz_id" ON "resultados_quiz"("quiz_id");

-- CreateIndex
CREATE INDEX "idx_resultados_quiz_usuario_id" ON "resultados_quiz"("usuario_id");

-- CreateIndex
CREATE INDEX "idx_metas_usuario_id" ON "metas"("usuario_id");

-- CreateIndex
CREATE INDEX "idx_investimentos_tipo_investimento_id" ON "investimentos"("tipo_investimento_id");

-- CreateIndex
CREATE INDEX "idx_investimentos_usuario_id" ON "investimentos"("usuario_id");

-- CreateIndex
CREATE UNIQUE INDEX "uniq_reservas_emergencia_usuario_id" ON "reservas_emergencia"("usuario_id");

-- CreateIndex
CREATE INDEX "idx_movimentacoes_usuario_id" ON "movimentacoes"("usuario_id");

-- AddForeignKey
ALTER TABLE "assinaturas" ADD CONSTRAINT "assinaturas_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "progresso_cursos" ADD CONSTRAINT "progresso_cursos_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "progresso_cursos" ADD CONSTRAINT "progresso_cursos_ibfk_2" FOREIGN KEY ("curso_id") REFERENCES "cursos"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "quizzes" ADD CONSTRAINT "quizzes_ibfk_1" FOREIGN KEY ("curso_id") REFERENCES "cursos"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "questoes" ADD CONSTRAINT "questoes_ibfk_1" FOREIGN KEY ("quiz_id") REFERENCES "quizzes"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "resultados_quiz" ADD CONSTRAINT "resultados_quiz_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "resultados_quiz" ADD CONSTRAINT "resultados_quiz_ibfk_2" FOREIGN KEY ("quiz_id") REFERENCES "quizzes"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "metas" ADD CONSTRAINT "metas_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "investimentos" ADD CONSTRAINT "investimentos_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "investimentos" ADD CONSTRAINT "investimentos_ibfk_2" FOREIGN KEY ("tipo_investimento_id") REFERENCES "tipos_investimento"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "reservas_emergencia" ADD CONSTRAINT "reservas_emergencia_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE "movimentacoes" ADD CONSTRAINT "movimentacoes_ibfk_1" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
