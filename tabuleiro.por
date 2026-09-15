programa
{
    inclua biblioteca Util --> u

    cadeia tabuleiro[5][5]
    inteiro nivel[5][5]

    inteiro bateria = 100
    inteiro creditosObtidos = 0
    inteiro rodadas = 0
    inteiro tesouroEncontrado = 0
    inteiro posicaoRisco = 0

    inteiro limiteNivel1 = 0
    inteiro limiteNivel2 = 0


    // ==========================================
    // FUNÇÃO PARA ARREDONDAMENTO CONVENCIONAL
    // ==========================================
    funcao inteiro Arredondar(real numero)
    {
        inteiro parteInteira
        real parteDecimal

        parteInteira = numero
        parteDecimal = numero - parteInteira

        se (parteDecimal < 0.5)
        {
            retorne parteInteira
        }
        senao
        {
            retorne parteInteira + 1
        }
    }


    // ==========================================
    // DIMINUIR BATERIA
    // ==========================================
    funcao DiminuirBateria()
    {
        bateria = bateria - 10
    }


    // ==========================================
    // APLICAR BONUS
    // ==========================================
    funcao Bonus(inteiro valor)
    {
        bateria = bateria + valor
        creditosObtidos = creditosObtidos + valor
    }


    // ==========================================
    // APLICAR RISCO
    // ==========================================
    funcao Risco()
    {
        bateria = bateria - 3
    }


    // ==========================================
    // GERAR CENARIO
    // ==========================================
    funcao GerarCenario(real percentual1, real percentual2, real percentual3)
    {
        inteiro i
        inteiro j
        inteiro casa

        inteiro posB05
        inteiro posB10
        inteiro posRisco
        inteiro posTesouro

        inteiro linha
        inteiro coluna

        real calculoNivel1
        real calculoNivel2


        // Calcula os limites dos níveis
        calculoNivel1 = 25 * percentual1 / 100
        calculoNivel2 = 25 * (percentual1 + percentual2) / 100

        limiteNivel1 = Arredondar(calculoNivel1)
        limiteNivel2 = Arredondar(calculoNivel2)


        // Garante pelo menos uma casa no Nivel I
        se (limiteNivel1 < 1)
        {
            limiteNivel1 = 1
        }


        // Garante que o Nivel II comece depois do Nivel I
        se (limiteNivel2 <= limiteNivel1)
        {
            limiteNivel2 = limiteNivel1 + 1
        }


        // Garante que o Nivel III tenha pelo menos uma casa
        se (limiteNivel2 >= 25)
        {
            limiteNivel2 = 24
        }


        // ======================================
        // PREENCHE A MATRIZ
        // ======================================
        para (i = 0; i < 5; i++)
        {
            para (j = 0; j < 5; j++)
            {
                tabuleiro[i][j] = "---"

                casa = i * 5 + j + 1


                // Define o nivel da casa
                se (casa <= limiteNivel1)
                {
                    nivel[i][j] = 1
                }
                senao
                {
                    se (casa <= limiteNivel2)
                    {
                        nivel[i][j] = 2
                    }
                    senao
                    {
                        nivel[i][j] = 3
                    }
                }
            }
        }


        // ======================================
        // SORTEIA B05
        // ======================================
        posB05 = u.sorteia(0, 24)

        linha = posB05 / 5
        coluna = posB05 % 5

        tabuleiro[linha][coluna] = "B05"


        // ======================================
        // SORTEIA B10
        // ======================================
        faca
        {
            posB10 = u.sorteia(0, 24)
        }
        enquanto (posB10 == posB05)

        linha = posB10 / 5
        coluna = posB10 % 5

        tabuleiro[linha][coluna] = "B10"


        // ======================================
        // SORTEIA RISCO
        // O risco não pode ficar no Nivel I
        // ======================================
        faca
        {
            posRisco = u.sorteia(0, 24)

            linha = posRisco / 5
            coluna = posRisco % 5
        }
        enquanto (
            posRisco == posB05 ou
            posRisco == posB10 ou
            nivel[linha][coluna] == 1
        )

        tabuleiro[linha][coluna] = "RIS"

        posicaoRisco = posRisco


        // ======================================
        // SORTEIA TESOURO
        // O tesouro não pode ficar no Nivel I
        // ======================================
        faca
        {
            posTesouro = u.sorteia(0, 24)

            linha = posTesouro / 5
            coluna = posTesouro % 5
        }
        enquanto (
            posTesouro == posB05 ou
            posTesouro == posB10 ou
            posTesouro == posRisco ou
            nivel[linha][coluna] == 1
        )

        tabuleiro[linha][coluna] = "$$$"
    }


    // ==========================================
    // MOSTRAR TABULEIRO
    // ==========================================
    funcao MostrarTabuleiro()
    {
        inteiro i
        inteiro j

        escreva("\n========== TABULEIRO ==========\n")

        para (i = 0; i < 5; i++)
        {
            para (j = 0; j < 5; j++)
            {
                escreva(tabuleiro[i][j], " ")
            }

            escreva("\n")
        }

        escreva("===============================\n")
    }


    // ==========================================
    // MOSTRAR RESULTADO
    // ==========================================
    funcao MostrarResultado()
    {
        inteiro nivelAtingido


        escreva("\n")
        escreva("========== RESULTADO DO JOGO ==========\n")


        MostrarTabuleiro()


        escreva("Bateria restante: ", bateria, "\n")
        escreva("Creditos obtidos: ", creditosObtidos, "\n")


        // Descobre o nivel atingido
        se (rodadas <= limiteNivel1)
        {
            nivelAtingido = 1
        }
        senao
        {
            se (rodadas <= limiteNivel2)
            {
                nivelAtingido = 2
            }
            senao
            {
                nivelAtingido = 3
            }
        }


        escreva("Nivel atingido: ", nivelAtingido, "\n")


        se (tesouroEncontrado == 1)
        {
            escreva("Tesouro encontrado: SIM\n")
        }
        senao
        {
            escreva("Tesouro encontrado: NAO\n")
        }


        escreva("Posicao do risco:\n")
        escreva("Casa: ", posicaoRisco + 1, "\n")


        escreva("Quantidade de rodadas: ", rodadas, "\n")


        escreva("=======================================\n")
    }


    // ==========================================
    // INICIO DO PROGRAMA
    // ==========================================
    funcao inicio()
    {
        real percentual1
        real percentual2
        real percentual3
        real soma

        inteiro posicao
        inteiro linha
        inteiro coluna


        escreva("=======================================\n")
        escreva("          CACA AO TESOURO\n")
        escreva("=======================================\n")


        // ======================================
        // PEDIR OS PERCENTUAIS
        // ======================================
        faca
        {
            escreva("\nDigite o percentual do Nivel I: ")
            leia(percentual1)

            escreva("Digite o percentual do Nivel II: ")
            leia(percentual2)

            escreva("Digite o percentual do Nivel III: ")
            leia(percentual3)


            soma = percentual1 + percentual2 + percentual3


            se (
                percentual1 < 0 ou
                percentual2 < 0 ou
                percentual3 < 0 ou
                percentual1 > 100 ou
                percentual2 > 100 ou
                percentual3 > 100 ou
                soma != 100
            )
            {
                escreva("\nValores invalidos!\n")
                escreva("A soma dos tres percentuais deve ser exatamente 100%.\n")
            }

        }
        enquanto (
            percentual1 < 0 ou
            percentual2 < 0 ou
            percentual3 < 0 ou
            percentual1 > 100 ou
            percentual2 > 100 ou
            percentual3 > 100 ou
            soma != 100
        )


        // ======================================
        // GERA O CENARIO
        // ======================================
        GerarCenario(percentual1, percentual2, percentual3)


        // ======================================
        // MOSTRA OS NIVEIS CALCULADOS
        // ======================================
        escreva("\n=======================================\n")
        escreva("NIVEIS CALCULADOS\n")


        escreva(
            "Nivel I: casas 01 a ",
            limiteNivel1,
            "\n"
        )


        escreva(
            "Nivel II: casas ",
            limiteNivel1 + 1,
            " a ",
            limiteNivel2,
            "\n"
        )


        escreva(
            "Nivel III: casas ",
            limiteNivel2 + 1,
            " a 25\n"
        )


        escreva("=======================================\n")


        // ======================================
        // PERCORRE AS 25 CASAS
        // ======================================
        para (posicao = 0; posicao < 25; posicao++)
        {
            // Verifica se existe bateria suficiente
            // para iniciar uma nova rodada
            se (bateria < 10)
            {
                pare
            }


            linha = posicao / 5
            coluna = posicao % 5


            rodadas = rodadas + 1


            escreva("\nRodada ", rodadas)
            escreva(" - Casa ", posicao + 1)
            escreva(" [", linha, ",", coluna, "]")


            // Cada rodada custa 10 de bateria
            DiminuirBateria()


            // ==================================
            // VERIFICA O CONTEUDO DA CASA
            // ==================================

            se (tabuleiro[linha][coluna] == "B05")
            {
                escreva(" -> Bonus de 05 creditos")

                Bonus(5)
            }
            senao
            {
                se (tabuleiro[linha][coluna] == "B10")
                {
                    escreva(" -> Bonus de 10 creditos")

                    Bonus(10)
                }
                senao
                {
                    se (tabuleiro[linha][coluna] == "RIS")
                    {
                        escreva(" -> Risco! -3 bateria")

                        Risco()
                    }
                    senao
                    {
                        se (tabuleiro[linha][coluna] == "$$$")
                        {
                            escreva(" -> TESOURO ENCONTRADO!")

                            tesouroEncontrado = 1

                            pare
                        }
                        senao
                        {
                            escreva(" -> Casa vazia")
                        }
                    }
                }
            }


            escreva(" | Bateria: ", bateria)
        }


        // ======================================
        // MOSTRA O RESULTADO FINAL
        // ======================================
        MostrarResultado()
    }
}
