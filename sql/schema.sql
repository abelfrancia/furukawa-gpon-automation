CREATE DATABASE IF NOT EXISTS isp_subscribers CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE isp_subscribers;

CREATE TABLE IF NOT EXISTS clientes (
    idCliente       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nomeCliente     VARCHAR(120) NOT NULL,
    cpfCliente      VARCHAR(20)  NOT NULL,
    endCliente      VARCHAR(255) NOT NULL,
    contatoCliente  VARCHAR(40)  NOT NULL,
    emailCliente    VARCHAR(120) DEFAULT NULL,
    planoCliente    VARCHAR(60)  NOT NULL,
    statusCliente   ENUM('ATIVO', 'BLOQUEADO', 'CANCELADO') NOT NULL DEFAULT 'ATIVO',
    oltCliente      VARCHAR(32)  NOT NULL,
    poltCliente     VARCHAR(16)  NOT NULL,
    onuCliente      INT UNSIGNED NOT NULL,
    macCliente      VARCHAR(32)  NOT NULL,
    createdAt       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updatedAt       TIMESTAMP    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_mac (macCliente),
    INDEX idx_olt_pon_onu (oltCliente, poltCliente, onuCliente)
) ENGINE=InnoDB;
