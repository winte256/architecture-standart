workspace "Банк Стандарт" "" {

    !identifiers hierarchical

    model {
        uCallCenter = person "Сотрудник колл-центра" {
            description "Сотрудник колл-центра, который принимает звонки и обрабатывает их"
        }
        uColdClient = person "Холодный клиент" {
            description "Клиент, который не является клиентом банка, но интересуется его услугами"
        }
        uClient = person "Клиент" {
            description "Клиент, который пользуется услугами банка"
        }
        uBackOffice = person "Сотрудник бэк-офиса" {
            description "Сотрудник бэк-офиса, который обрабатывает запросы клиентов"
        }

        sBank = softwareSystem "Банк Стандарт" {
            description "Банк Стандарт"
            sInternetBank = container "Интернет-банк" {
                description "Интернет-банк, который позволяет клиентам управлять своими счетами и проводить операции"
                technology "ASP.NET MVC 4.5 + MS SQL"

                frontend = component "Frontend" {
                    description "Фронтенд интернет-банка"
                    technology "React.js"
                }
                backend = component "Backend" {
                    description "Бэкенд интернет-банка"
                    technology "ASP.NET MVC 4.5"
                }
                depositService = component "Сервис депозитов" {
                    description "Обрабатывает заявки на депозиты, считает ставки, общается с АБС"
                    technology "C#"
                }
                smsService = component "Сервис отправки СМС" {
                    description "Отправляет клиенту СМС, когда надо что-то подтвердить"
                    technology "C#"
                }
                integrationLayer = component "Интеграционный слой" {
                    description "Прослойка между интернет-банком и АБС"
                    technology "C#"
                }
                db = component "База данных интернет-банка" {
                    technology "MS SQL"
                }
            }
            sABS = container "Автоматизированная банковская система" {
                technology "Delphi + Oracle"

                depositModule = component "Модуль депозитов" {
                    description "Логика по депозитам и ставкам"
                    technology "PL-SQL"
                }
                accountModule = component "Модуль счетов" {
                    description "Работает со счетами клиентов"
                    technology "PL-SQL"
                }
                integrationModule = component "Модуль интеграции" {
                    description "Обеспечивает интеграцию с другими системами"
                    technology "PL-SQL"
                }
                dbABS = component "База данных АБС" {
                    technology "Oracle"
                }
            }
            sWebsite = container "Сайт" {
                description "Сайт банка, на котором клиенты могут узнать о банке и его услугах"
                technology "PHP + React.js"
            }
            sCallCenter = container "Система колл-центра" {
                description "Система колл-центра, которая обрабатывает звонки клиентов"
                technology "React.js + Java Spring Boot + PostgreSQL"
            }
            sSMSGateway = container "СМС-шлюз" {
                description "СМС-шлюз, который отправляет СМС-сообщения клиентам"
                technology ""
            }

            sInternetBank.frontend -> sInternetBank.backend "Запросы от клиента"
            sInternetBank.backend -> sInternetBank.depositService "Обработка заявок на депозиты"
            sInternetBank.backend -> sInternetBank.smsService "Отправка СМС"
            sInternetBank.backend -> sInternetBank.db "Чтение/запись данных"
            sInternetBank.depositService -> sInternetBank.integrationLayer "Запросы к АБС"
            sInternetBank.integrationLayer -> sABS "Запросы на открытие депозита"
            sInternetBank.smsService -> sSMSGateway "Отправка СМС"

            sABS.integrationModule -> sABS.depositModule "Передаёт заявки на депозиты"
            sABS.depositModule -> sABS.dbABS "Читает/пишет депозиты"
            sABS.accountModule -> sABS.dbABS "Читает/пишет счета"
            sABS.integrationModule -> sABS.dbABS "Читает/пишет интеграционные данные"
            sABS.integrationModule -> sSMSGateway "Отправка СМС клиенту"

            uColdClient -> sWebsite "Смотрит инфу, оставляет заявку"
            uCallCenter -> sCallCenter "Обрабатывает звонки"
            uClient -> sInternetBank "Подаёт заявку на депозит"
            uBackOffice -> sABS "Обрабатывает заявки"

            sSMSGateway -> uClient "Отправляет СМС"
            sInternetBank -> sABS "Запросы на депозиты через интеграционный слой"
            sABS -> sSMSGateway "Отправка СМС"
            sWebsite -> sCallCenter "Передаёт заявки с сайта"
        }
    }

    views {
        systemContext sBank "Context" {
            include *
            autolayout tb
        }

        container sBank "Containers" {
            include *
            autolayout tb
        }

        component sBank.sInternetBank "IBank-Components" {
            include *
            autolayout lr
        }

        component sBank.sABS "ABS-Components" {
            include *
            autolayout lr
        }

        styles {
            element "Person" {
                background #d34407
                shape person
            }
            element "Element" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }
            element "Database" {
                shape cylinder
            }
            element "Group: Frontend" {
                background #ffcc00
            }
        }
    }

    configuration {
        scope softwareSystem
    }
}
