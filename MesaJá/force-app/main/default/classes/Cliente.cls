public with sharing class Cliente{
    //Atributos
    private String nome;
    private Documento documento;

    //Metodos de acesso
    public String getNome() { return nome; }
    public Documento getDocumento() { return documento; }

    //Construtor
    public Cliente(String nome, String cpf) {
        this.nome = nome;
        this.documento = new Documento(cpf);
    }
}