-- SQLite schema

PRAGMA foreign_keys = ON;

-- Tabelas
CREATE TABLE IF NOT EXISTS clientes (
  codigo INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  cidade TEXT,
  uf TEXT
);

CREATE TABLE IF NOT EXISTS produtos (
  codigo INTEGER PRIMARY KEY,
  descricao TEXT NOT NULL,
  preco_venda REAL NOT NULL
);

CREATE TABLE IF NOT EXISTS pedidos (
  numero INTEGER PRIMARY KEY,
  data_emissao DATE NOT NULL,
  codigo_cliente INTEGER NOT NULL,
  valor_total REAL NOT NULL DEFAULT 0,
  FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

CREATE TABLE IF NOT EXISTS pedidos_itens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  numero_pedido INTEGER NOT NULL,
  codigo_produto INTEGER NOT NULL,
  quantidade REAL NOT NULL,
  valor_unitario REAL NOT NULL,
  valor_total REAL NOT NULL,
  FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero) ON DELETE CASCADE,
  FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Indices
CREATE INDEX IF NOT EXISTS idx_pedidos_cliente ON pedidos(codigo_cliente);
CREATE INDEX IF NOT EXISTS idx_itens_numero ON pedidos_itens(numero_pedido);

-- Clientes ficticios
INSERT OR IGNORE INTO clientes (codigo, nome, cidade, uf) VALUES (1, 'Cliente A', 'São Paulo', 'SP');
INSERT OR IGNORE INTO clientes (codigo, nome, cidade, uf) VALUES (2, 'Cliente B', 'Rio de Janeiro', 'RJ');
INSERT OR IGNORE INTO clientes (codigo, nome, cidade, uf) VALUES (3, 'Cliente C', 'Belo Horizonte', 'MG');

-- Produtos ficticios
INSERT OR IGNORE INTO produtos (codigo, descricao, preco_venda) VALUES (1, 'Produto X', 10.50);
INSERT OR IGNORE INTO produtos (codigo, descricao, preco_venda) VALUES (2, 'Produto Y', 25.90);
INSERT OR IGNORE INTO produtos (codigo, descricao, preco_venda) VALUES (3, 'Produto Z', 7.30);
INSERT OR IGNORE INTO produtos (codigo, descricao, preco_venda) VALUES (4, 'Produto Premium', 99.99);

-- Sequência de pedidos
CREATE TABLE IF NOT EXISTS seq_pedidos (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  numero INTEGER NOT NULL
);

INSERT OR IGNORE INTO seq_pedidos (id, numero) VALUES (1, 0);