//Criando clientes
Cliente c1 = new Cliente('Ana Silva', '111.111.111-11');
Cliente c2 = new Cliente('Bruno Costa', '222.222.222-22');
Cliente c3 = new Cliente('Carla Souza', '333.333.333-33');
Cliente c4 = new Cliente('Marcos Feliciano', '444.444.444-44');

Restaurante restA = new Restaurante('MesaJa Jardins', 'Av. Paulista, 1000');
Restaurante restB = new Restaurante('MesaJa Centro', 'Rua Direita, 50');

Mesa m1 = new Mesa(1, 4, LocalMesa.SALAO);
Mesa m2 = new Mesa(2, 6, LocalMesa.SALAO);
Mesa m3 = new Mesa(3, 4, LocalMesa.JARDIM);
Mesa m4 = new Mesa(4, 2, LocalMesa.SALAO);
Mesa m5 = new Mesa(5, 4, LocalMesa.JARDIM);

restA.adicionarMesa(m1);
restA.adicionarMesa(m2);
restA.adicionarMesa(m3);
restA.adicionarMesa(m4);
restA.adicionarMesa(m5);

restB.adicionarMesa(m1);
restB.adicionarMesa(m2);
restB.adicionarMesa(m3);
restB.adicionarMesa(m4);
restB.adicionarMesa(m5);

System.debug('[saida] Reserva da Ana');
Restaurante.Reserva resAna = restA.criarReserva(c1, 3, LocalMesa.SALAO, PeriodoReserva.NOITE, true);
System.debug('\n');
System.debug('[saida] Reserva do Bruno');
Restaurante.Reserva resBruno = restA.criarReserva(c2, 4, LocalMesa.SALAO, PeriodoReserva.NOITE, true);
System.debug('\n');
System.debug('[saida] Reserva da Carla');
Restaurante.Reserva resCarla = restA.criarReserva(c3, 2, LocalMesa.SALAO, PeriodoReserva.NOITE, true);
System.debug('\n');
System.debug('[saida] Reserva do Marcos');
Restaurante.Reserva resMarcos1 = restA.criarReserva(c4, 1, LocalMesa.SALAO, PeriodoReserva.MANHA, true);
System.debug('\n');
Restaurante.Reserva resMarcos2 = restB.criarReserva(c4, 1, LocalMesa.JARDIM, PeriodoReserva.MANHA, true);
System.debug('\n');


List<Documento> cpfsPesquisados = new List<Documento>{ c1.getDocumento(), c2.getDocumento(), c3.getDocumento(), c4.getDocumento() };
List<Restaurante> listaRestaurantes = new List<Restaurante>{ restA, restB };

Map<Documento, List<Restaurante.Reserva>> relatorio = RelatorioReservasService.gerarRelatorioReservasConfirmadasPorCpf(cpfsPesquisados, listaRestaurantes);

for(Documento cpf : relatorio.keySet()){
    for(Restaurante.Reserva r : relatorio.get(cpf)){
        System.debug(r.getCliente());
        System.debug(r.getMesa());
        System.debug(r.getRestaurante().getNome());
    }
}
