; Queria ter mudado a cor da aplicação, mas o racket não quis colaborar comigo
; Autora: Letícia Karolina Moreira
#lang racket/gui
(require racket/gui/base
         racket/gui
         db
         2htdp/batch-io)
; Cria um novo frame
(define frame (new frame%
                   [label "Bas-káa-ra"]
                   [width 800]
                   [height 400]
                   [border 15]
                   ))
(define firstmessage (new message%
     [parent frame]
     [label "Insira os valores e pressione o botão calcular \n para mostrar os resultados da operação !"]))
; Cria um novo painel para armazenar os text-fields de inserção de valores
(define panel (new vertical-panel%
                   [parent frame]
                   ))
(define a (new text-field%
               [label "Valor de x²    "]
               [horiz-margin 5]
               [parent panel]
               ))
(define b (new text-field%
               [label "Valor de x¹    "]
               [horiz-margin 5]
               [parent panel]
               ))
(define c (new text-field%
               [label "Valor de c     "]
               [horiz-margin 5]
               [parent panel]
               ))
(define panel2 (new horizontal-panel%
                    [parent frame]
                    [vert-margin 15]))
(define field1 (new text-field%
                    [parent panel2]
                    [label "Delta  "]
                    ; [enabled #f]
                    [horiz-margin 5]
                    ))
(define field2 (new text-field%
                    [parent panel2]
                    [label "Raiz 1 "]
                    ; [enabled #f]
                    ))
(define field3 (new text-field%
                    [parent panel2]
                    [label "Raiz 2 "]
                    ; [enabled #f]
                    ))
(define field4 (new text-field%
                    [parent panel2]
                    [label "Vértice x "]
                    ; [enabled #f]
                    ))
(define field5 (new text-field%
                    [parent panel2]
                    [label "Vértice y "]
                    ; [enabled #f]
                    ))
(define panel3 (new horizontal-panel%
                    [parent frame]
                    [horiz-margin 270]))
(define button1 (new button%
                    [parent panel3]
                    [label "Calcular Valores"]
                    ; Ação a ser executada quando o botão for clicado
                    [callback (lambda (button event)
                                ; Valores dos text-fields sendo pegos
                                (define value1 (string->number(send a get-value)))
                                (define value2 (string->number(send b get-value)))
                                (define value3 (string->number(send c get-value)))
                                ; Mensagem vazia criada para posterior alteração
                                (define message (new message% [parent frame]
                                                     [label ""]))
                                ; Verifica se os valores inseridos são inteiros (somente números)
                                (if (number? value1 )
                                    (send message set-label "Tome nota: Para uma nova expressão, aperte no botão Nova Conta !")
                                    (send firstmessage set-label "Somente valores inteiros serão aceitos !")
                                    )
                                (if (number? value2 )
                                    (send message set-label "Tome nota: Para uma nova expressão, aperte no botão Nova Conta !")
                                    (send firstmessage set-label "Somente valores inteiros serão aceitos !")
                                    )
                                (if (number? value3 )
                                    (send message set-label "Tome nota: Para uma nova expressão, aperte no botão Nova Conta !")
                                    (send firstmessage set-label "Somente valores inteiros serão aceitos !")
                                    )
                                ; Verifica se o valor de a é diferente de zero, para não cair numa divisão por zero
                                (if (= 0 value1)
                                    (send firstmessage set-label "O valor de a não pode ser igual a 0 !")
                                    (send message set-label "Tome nota: Para uma nova expressão, aperte no botão Nova Conta !")
                                    )
                                ; Chama a função passando como parametro os valores dos text-fields
                                (define results (function value1 value2 value3))
                                ; Desativa o botão calcular enquanto a conta ainda estiver na tela                       
                                (send button1 enable #f)
                                ; Mostra o resultado nos campos
                                (send field1 set-value (number->string(first results)))
                                (send field2 set-value (number->string(second results)))
                                (send field3 set-value (number->string(third results)))
                                (send field4 set-value (number->string(round(fourth results))))
                                (send field5 set-value (number->string(round(fifth results))))
                                ; Esse comando se faz necessária devido ao button2 (Nova Conta), pois na ação do button2 o painel dos resultados é oculto
                                (send panel2 show #t)
                                ; Insere os arquivos no banco de dados
                                (write results value1 value2 value3)
                                )]))
(define button2 (new button% [parent panel3]
                     [label "Nova Conta"]
                     [callback (lambda (button event)
                                 ; Ativa o botão calcular, pois uma nova conta foi iniciada
                                 (send button1 enable #t)
                                 ; Deixa os campos de a b e c em branco para uma nova conta
                                 (send a set-value "")
                                 (send b set-value "")
                                 (send c set-value "")
                                 ; Oculta o painel dos resultados
                                 (send panel2 show #f)
                                 )]))
; Mostra a janela que foi criada
(send frame show #t)
(define (write results a b c)
  
  (define pgc
    (mysql-connect
     #:user "root"
     #:port 3306
     #:database "racket_project"
     #:server "localhost"
     #:password "xxxxx"
     )
    )
  
  (query-exec pgc "INSERT INTO `results` VALUES (DEFAULT,?,?,?,?,?,?,?,?)" a b c (first results) (second results) (third results) (fourth results) (fifth results))
  )
; Função pra calcular delta, x1, x2, v1, v2, respectivamente
(define (function a b c) 
  (define (delta)
    (-(* b b)(* 4 a c))
    );
  (define (x1)
    (/(+(sqrt (delta))(* -1 b))(* 2 a))
    );
  (define (x2)
    (/(-(* -1 b)(sqrt (delta)))(* 2 a))
    );
  (define (v1)
    (/(* -1 b)(* 2 a))
    );
  (define (v2)
    (/(* -1 (delta))(* 4 a));
    );
  (list (delta) (x1) (x2) (v1) (v2))
  );