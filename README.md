# RI_TP2

## Descrição

Este projeto é o Trabalho Prático 2 da disciplina de Robótica Industrial. O objetivo principal é simular, em MATLAB, o robô **Yaskawa SDA10F**, que possui **15 graus de liberdade**. Neste trabalho, o robô é modelado como dois braços de **8 graus de liberdade**, compartilhando um elo comum.

🎯 **Nota Máxima**: Este trabalho recebeu a pontuação máxima na disciplina de Robótica Industrial.  

O robô tem a função de:
1. Apanhar dois blocos de tapetes diferentes.
2. Juntá-los à sua frente.
3. Girar **180 graus**.
4. Colocá-los sobre um terceiro tapete.
5. Retornar à posição inicial para repetir o processo.

## 📂 Estrutura do Projeto

- `Main.m` → Arquivo principal que executa a simulação do robô.
- `Functions/` → Contém as funções auxiliares usadas no projeto.
- `tp2.txt` → Arquivo de configuração inicial com parâmetros ajustáveis.
- `Robótica_Industrial_TP2.pdf` → Relatório detalhado do projeto.
 
---

## ⚙️ Funcionalidades Implementadas

### 1️⃣ Cinemática Direta
- Construção da **tabela de Denavit-Hartenberg (DH)** para os dois braços.
- Cálculo da posição e orientação do end-effector.

### 2️⃣ Cinemática Inversa
- Uso de uma abordagem **analítica** para calcular os ângulos das juntas.
- Adaptação dos parâmetros DH para facilitar o cálculo.
- Implementação de restrições para evitar redundâncias e garantir viabilidade.

### 3️⃣ Cinemática Diferencial
- Uso da **matriz Jacobiana** para permitir movimentos lineares.
- Implementação de um sistema iterativo para reduzir erros.



