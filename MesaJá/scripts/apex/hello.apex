Cliente c1 = new Cliente('Ana Silva', '111.111.111-11');
Cliente c2 = new Cliente('Bruno Costa', '222.222.222-22');
Cliente c3 = new Cliente('Carla Souza', '333.333.333-33');

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

Reserva resAna = restA.criarReserva(c1, 3, LocalMesa.SALAO, PeriodoReserva.NOITE, true);
Reserva resBruno = restA.criarReserva(c2, 4, LocalMesa.SALAO, PeriodoReserva.NOITE, true);
Reserva resCarla = restA.criarReserva(c3, 2, LocalMesa.SALAO, PeriodoReserva.NOITE, true);

restA.cancelarReserva(resAna);

List<String> cpfsPesquisados = new List<String>{ '111.111.111-11', '222.222.222-22', '333.333.333-33' };
List<Restaurante> listaRestaurantes = new List<Restaurante>{ restA, restB };

Restaurante.gerarRelatorioReservasConfirmadasPorCpf(cpfsPesquisados, listaRestaurantes);
