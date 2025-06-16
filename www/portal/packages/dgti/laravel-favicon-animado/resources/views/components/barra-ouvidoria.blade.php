<style>
    @media only screen and (min-width: 1200px) {
        .linha {
            width: 1170px;
        }
    }

    @media only screen and (min-width: 992px) {
        .linha {
            width: 1170px;
        }
    }

    @media only screen and(min-width: 768px) {
        .linha {
            width: 750px;
        }
    }

    .linha {
        margin-right: auto;
        margin-left: auto;
        padding: 2px 0px 2px 0px;
        align-self: center;
    }

    /* CSS Barra LIGHT */

    .bar_light {
        background: linear-gradient(34deg, rgba(250, 250, 250, 1) 34%, rgba(193, 193, 193, 1) 58%);
        display: flex;
        justify-content: flex-end;
        text-decoration: none;
        text-transform: uppercase;
        font-family: "Raleway", Sans-serif;
        font-size: 0.7rem;
        font-weight: 600;
        align-items: center;
    }

    /* Fim código Barra Light */

    .bar_blue {
        background: linear-gradient(34deg, rgba(0, 53, 131, 1) 34%, rgba(18, 45, 83, 1) 58%);
        display: flex;
        justify-content: flex-end;
        text-decoration: none;
        text-transform: uppercase;
        font-family: "Raleway", Sans-serif;
        font-size: 1.1rem;
        font-weight: 500;
        align-items: baseline;
    }

    .bar_dark {
        background: linear-gradient(34deg, rgba(47, 47, 47, 1) 34%, rgba(0, 0, 0, 1) 58%);
        display: flex;
        justify-content: flex-end;
        text-decoration: none;
        text-transform: uppercase;
        font-family: "Raleway", Sans-serif;
        font-size: 1.1rem;
        font-weight: 500;
        align-items: baseline;
    }

    /* Acessibilidade: foco visível */
    .barra-ouvidoria-link:focus {
        outline: 3px solid #005fcc;
        outline-offset: 2px;
        background: #e6f0fa;
    }

    /* Screen reader only */
    .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        border: 0;
    }

    /* Melhor layout para lista de links */
    .barra-ouvidoria-list {
        list-style: none;
        display: flex;
        flex-direction: row;
        gap: 1.5em;
        margin: 0;
        padding: 0;
        justify-content: flex-end;
    }

    .barra-ouvidoria-item {
        display: flex;
        align-items: center;
    }

    /* Versão alternativa - defina a cor padrão no CSS */
    .barra-ouvidoria-link {
        color: #152f4e;
        text-decoration: none;
        font-weight: 600;
        transition: all 0.3s ease;
    }

    .barra-ouvidoria-link:hover {
        color: #005fcc;
        text-shadow: 2px 2px 4px rgba(0, 95, 204, 0.3);
    }

    /* Layout responsivo para a lista de links */
    @media only screen and (max-width: 767px) {
        .barra-ouvidoria-list {
            gap: 0.8em;
            padding: 0.5em 1em;
        }

        .bar_light {
            font-size: 0.6rem;
            padding: 0.5em 0;
        }

        .linha {
            width: 100%;
            padding: 0;
        }

        /* Ocultar ícones em telas pequenas para economizar espaço */
        .barra-ouvidoria-link i {
            display: none;
        }

        /* Ajustar espaçamento do texto */
        .barra-ouvidoria-link span[aria-hidden="true"] {
            margin-left: 0 !important;
        }

        /* Adicionar separador vertical entre os links */
        .barra-ouvidoria-item:not(:last-child)::after {
            content: "|";
            color: #152f4e;
            margin-left: 0.8em;
            font-weight: 400;
            opacity: 0.6;
        }
    }

    @media only screen and (max-width: 480px) {
        .bar_light {
            font-size: 0.55rem;
        }

        .barra-ouvidoria-list {
            gap: 0.6em;
        }

        /* Ajustar separador para telas muito pequenas */
        .barra-ouvidoria-item:not(:last-child)::after {
            margin-left: 0.6em;
        }

        /* Textos mais curtos para telas muito pequenas */
        .barra-ouvidoria-link[aria-label*="Ouvidoria"] span[aria-hidden="true"]::after {
            content: "Ouvidoria";
        }

        .barra-ouvidoria-link[aria-label*="Lei Geral"] span[aria-hidden="true"]::after {
            content: "LGPD";
        }

        .barra-ouvidoria-link[aria-label*="Acesso"] span[aria-hidden="true"]::after {
            content: "Acesso à Informação";
        }

        /* Ocultar texto original e mostrar versão curta */
        .barra-ouvidoria-link span[aria-hidden="true"] {
            font-size: 0;
        }

        .barra-ouvidoria-link span[aria-hidden="true"]::after {
            font-size: 0.55rem;
        }
    }

    @media only screen and (min-width: 768px) and (max-width: 991px) {
        .barra-ouvidoria-list {
            gap: 1.2em;
        }

        .bar_light {
            font-size: 0.65rem;
        }
    }

    /* Melhorar o hover em dispositivos touch */
    @media (hover: hover) {
        .barra-ouvidoria-link:hover {
            color: #005fcc !important;
            text-shadow: 2px 2px 4px rgba(0, 95, 204, 0.3);
            transition: all 0.3s ease;
        }
    }

    /* Para dispositivos touch, usar active ao invés de hover */
    @media (hover: none) {
        .barra-ouvidoria-link:active {
            color: #005fcc !important;
            text-shadow: 2px 2px 4px rgba(0, 95, 204, 0.3);
        }
    }

    /* Transição suave para todos os links */
    .barra-ouvidoria-link {
        transition: all 0.3s ease;
    }
</style>

<nav class="bar_light" aria-label="Links institucionais">
    <div class="linha">
        <ul class="barra-ouvidoria-list">
            <li class="barra-ouvidoria-item">
                <a href="https://www.ouvidoria.uerj.br" target="_blank" rel="noopener noreferrer"
                    class="barra-ouvidoria-link" aria-label="Ouvidoria Geral da Uerj (abre em nova aba)">
                    <i class="fas fa-comment" aria-hidden="true"></i>
                    <span class="sr-only">Ouvidoria Geral da Uerj</span>
                    <span aria-hidden="true">&nbsp;Ouvidoria Geral da Uerj</span>
                </a>
            </li>
            <li class="barra-ouvidoria-item">
                <a href="https://www.uerj.br/lei-geral-de-protecao-de-dados-pessoais-lgpd" target="_blank"
                    rel="noopener noreferrer" class="barra-ouvidoria-link"
                    aria-label="Lei Geral de Proteção de Dados (abre em nova aba)">
                    <i class="fas fa-lock" aria-hidden="true"></i>
                    <span class="sr-only">Lei Geral de Proteção de Dados</span>
                    <span aria-hidden="true">&nbsp;Lei Geral de Proteção de Dados</span>
                </a>
            </li>
            <li class="barra-ouvidoria-item">
                <a href="https://www.rj.gov.br/ouverj" target="_blank" rel="noopener noreferrer"
                    class="barra-ouvidoria-link" aria-label="Acesso à Informação (abre em nova aba)">
                    <i class="fas fa-info-circle" aria-hidden="true"></i>
                    <span class="sr-only">Acesso à Informação</span>
                    <span aria-hidden="true">&nbsp;Acesso à Informação</span>
                </a>
            </li>
        </ul>
    </div>
</nav>
