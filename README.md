# Maquina-de-Bebidas-em-Assembly

### Letizia L. Baptistella RA 24.123.031-7 
### Rafaela Altheman de Campos RA 24.123.010-1

O objetivo deste projeto é simular em Assembly uma máquina de bebidas. Para isso, é informado as opções disponíveis e o usuário deve clicar no botão correspondente ao seu pedido para que seja informado sobre o status de preparação.

Para desenvolvimento, foi utilizado um simulador de 8051 chamado Edsim 51. Utilizmos as ferramentas que ele nos oferece e que aprendemos em aula para desenvolver a maquina de bebidas. Dentre eles estão: teclado matricial, LCD, motor e o display de 7 segmentos.

O trabalho foi desenvolvimento pensando em utilizar e dinamizar o maior numero de ferramentas do Edsim51 que pudemos usar.

Para utilizar a maquina de bebidas, ao rodar o programa, um menu das bebidas disponiveis aparece para o cliente. As opções são: água, suco, chá mate e Coca-Cola.

1- Tela de Inicio do programa:

![image](https://github.com/user-attachments/assets/190f6ef7-d471-4b73-b2ec-ebb5d547f2cb)

2- Primeiras opções de bebidas:

![image](https://github.com/user-attachments/assets/1ec21d92-679c-4005-8326-a7b92bab9e6f)

3- Outras opções de bebidas:

![image](https://github.com/user-attachments/assets/2b0a8490-da22-43a1-a37b-40a8626220fe)

4- Nesse momento o usuario deve escolher no teclado matricial a bebida que ele deseja:

![image](https://github.com/user-attachments/assets/bbb987e1-3db4-4570-b286-d865f68e84a0)

5- Assim que o usuário seleciona a bebida correspondente:

![image](https://github.com/user-attachments/assets/ad7989b9-54ae-4b9f-9c59-24c96931be68)

6- Após isso, o display de 7 segmentos faz uma contagem regressiva para a bebida ficar pronta enquanto o motor gira (ver vídeo do funcionamento do programa)

7- Assim que finalizada, o LCD informa que a preparação acabou

![image](lcd-bebida-pronta.png)


Vídeo do funcionamento completo do projeto:

[(https://youtu.be/OLv1d73Ig_A)]

# Fluxograma e explicação do código:

PDF fluxograma:

[Fluxogramas.pdf](https://github.com/user-attachments/files/17607107/Fluxogramas.pdf)

Explicação do código:

Resumindo as funções e sub-rotinas:

1. Mensagem na memória ROM:
   
  --> Declaramos mensagens que serão exibidas no LCD, como "Bem-vindo!", "Escolha sua bebida"...;
  
  --> Terminamos cada uma com 00h para indicar o final da string.

3. Função Start:
   
  --> A função start configura o teclado com valores específicos para as teclas e inicializa o LCD, exibindo as mensagens de boas-vindas e opções de bebidas disponíveis.

5. Sub-rotina Rotina:
   
  --> Nessa sub-rotina é necessário ler o teclado e identificar a tecla pressionada;
  
  --> Dependendo da tecla que foi pressionada, sendo as opções 1,2,3,4, a máquina prepara a bebida correspondente, exibe uma mensagem e inicia o movimento do motor.

7. Sub-rotina exibePreparacao:
   
  --> Exibe a mensagem de preparação da bebida escolhida e seleciona o movimento do motor com base na bebida.

9. Sub-rotina start2:
    
  --> Inicia uma contagem regressiva de 10 segundos, exibindo cada número no display de 7 segmentos;
  
  --> Após a contagem, o motor é desligado e a mensagem "Bebida Pronta!" é exibida no LCD.

11. Sub-rotinas auxiliares (vistas em aula):
    
  --> escreveStringROM
  
  --> lcd_init
  
  --> sendCharacter
  
  --> posicionaCursor
  
  --> clearDisplay

13. Sub-rotina leituraTeclado:
    
  --> Verifica cada linha do teclado matricial, chamando colScan para detectar qual é a coluna.

14. Sub-rotina colScan:

  --> Verifica nas colunas do teclado para identificar qual tecla foi pressionada.

15. Sub-rotinas de Delay:

  --> São implementadas várias funções de delay (delay, delay2) para garantir que as operações no display e os tempos de movimentação do motor aconteçam corretamente.

