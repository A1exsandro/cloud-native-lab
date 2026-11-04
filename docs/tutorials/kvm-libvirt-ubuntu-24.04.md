# Tutorial: Preparação do KVM/Libvirt no Ubuntu 24.04

**Projeto:** Cloud Native Lab\
**Etapa:** 1 --- Infraestrutura local\
**Status:** KVM/Libvirt instalado e acessível; rede NAT `default`
identificada, mas ainda inativa.\
**Host:** Ubuntu 24.04, processador AMD com suporte a AMD-V.

Este tutorial registra os comandos executados e os resultados observados
até a verificação da rede padrão do Libvirt. Ele não considera a criação
ou inicialização da rede como concluída.

------------------------------------------------------------------------

## 1. Verificar suporte à virtualização

Verificar se os módulos KVM estão carregados:

``` bash
lsmod | grep kvm
```

Resultado observado:

``` text
kvm_amd 253952 0
kvm 1507328 1 kvm_amd
irqbypass 16384 1 kvm
ccp 188416 1 kvm_amd
```

Verificar se a CPU disponibiliza virtualização:

``` bash
lscpu | grep -E 'Virtualization|Hypervisor'
```

Resultado observado:

``` text
Virtualization: AMD-V
```

**Conclusão:** o host possui suporte AMD-V e os módulos KVM estão
carregados.

## 2. Verificar os pacotes do KVM/Libvirt

Comando usado para consultar os pacotes:

``` bash
dpkg -l | grep -E 'qemu-kvm|libvirt|virt-manager'
```

Durante a consulta, o `dpkg` apresentou um aviso relacionado ao pacote
`profit`, informando ausência do campo `Maintainer` em
`/var/lib/dpkg/status`. Esse aviso não impediu a continuidade da
configuração do Libvirt.

> Observação: mantenha o aviso registrado. Não edite manualmente
> `/var/lib/dpkg/status` para tentar corrigi-lo.

## 3. Adicionar o usuário aos grupos necessários

Foi executado:

``` bash
sudo usermod -aG libvirt,kvm "$USER"
```

A primeira tentativa de consultar o Libvirt retornou erro de permissão,
pois a sessão ainda não havia atualizado os grupos do usuário.

Para atualizar os grupos na sessão do terminal, foram executados:

``` bash
newgrp libvirt
newgrp kvm
groups
```

Também foram conferidos os grupos:

``` bash
getent group libvirt
getent group kvm
```

Resultado observado:

``` text
libvirt:x:131:alexsandro-linux
kvm:x:993:alexsandro-linux
```

A saída de `groups` passou a incluir `libvirt` e `kvm`.

> Alternativa: encerrar a sessão do usuário e entrar novamente também
> atualiza a associação aos grupos.

## 4. Verificar e iniciar o serviço Libvirt

Foi consultado o estado do serviço:

``` bash
systemctl status libvirtd --no-pager
```

O serviço apareceu como `inactive (dead)`, mas estava habilitado e os
sockets do Libvirt estavam carregados. Isso pode ocorrer quando o
serviço utiliza ativação por socket.

Em seguida, foi executado:

``` bash
sudo systemctl enable --now libvirtd
```

E a conexão com o hipervisor do sistema foi testada:

``` bash
virsh -c qemu:///system list --all
```

Resultado observado:

``` text
 Id   Name   State
--------------------
```

A tabela vazia é esperada neste estágio: ainda não foi criada nenhuma
máquina virtual.

**Conclusão:** a conexão `qemu:///system` respondeu com sucesso.

## 5. Inspecionar a rede padrão do Libvirt

Listar as redes disponíveis:

``` bash
virsh -c qemu:///system net-list --all
```

Resultado observado:

``` text
 Name      State      Autostart   Persistent
----------------------------------------------
 default   inactive   no          yes
```

Consultar os detalhes da rede padrão:

``` bash
virsh -c qemu:///system net-info default
```

Resultado observado:

``` text
Name:           default
UUID:           78b9af57-43a8-4b9b-8acf-bb40f9ad6938
Active:         no
Persistent:     yes
Autostart:      no
Bridge:         virbr0
```

A rede `default` já está definida e é persistente, mas está inativa e
ainda não está configurada para iniciar automaticamente. A interface de
bridge esperada é `virbr0`.

## 6. Conferir as interfaces de rede do host

Foi executado:

``` bash
ip -br address
```

Interfaces relevantes observadas:

``` text
wlo1             UP             192.168.1.7/24
docker0          DOWN           172.17.0.1/16
cni0             UP             10.42.0.1/24
```

Também foram observadas várias bridges `br-*` criadas por ambientes de
contêineres.

**Atenção:** como o host já possui Docker e interfaces CNI, é importante
inspecionar a rede do Libvirt antes de ativá-la e confirmar que sua
faixa IP não conflita com as redes existentes.

------------------------------------------------------------------------

## 7. Estado atual e próximo passo

Até este ponto:

-   [x] Suporte AMD-V identificado.
-   [x] Módulos KVM carregados.
-   [x] Usuário incluído nos grupos `libvirt` e `kvm`.
-   [x] Conexão `qemu:///system` funcionando.
-   [x] Rede `default` encontrada e inspecionada.
-   [ ] Confirmar a faixa IP e as configurações da rede `default`.
-   [ ] Ativar a rede NAT `default`.
-   [ ] Configurar inicialização automática da rede.
-   [ ] Baixar ou localizar a ISO do Debian 13.
-   [ ] Criar a primeira VM Debian 13.
-   [ ] Instalar e validar acesso SSH à VM.

Antes de iniciar a rede, consultar sua definição:

``` bash
virsh -c qemu:///system net-dumpxml default
```

Depois de analisar o XML e confirmar que a faixa de rede não conflita
com as redes existentes, a ativação poderá ser feita com:

``` bash
sudo virsh -c qemu:///system net-start default
sudo virsh -c qemu:///system net-autostart default
```

Esses dois últimos comandos são **próximos passos sugeridos, ainda não
executados** no momento em que este tutorial foi escrito.

Validar posteriormente:

``` bash
virsh -c qemu:///system net-list --all
ip -br address
```

O resultado esperado, após uma ativação bem-sucedida, é a rede `default`
aparecer como `active`, com `Autostart` habilitado e a bridge `virbr0`
presente.

## 8. Comandos úteis de consulta

``` bash
# Listar VMs
virsh -c qemu:///system list --all

# Listar redes
virsh -c qemu:///system net-list --all

# Consultar uma rede
virsh -c qemu:///system net-info default

# Exibir a definição XML da rede
virsh -c qemu:///system net-dumpxml default

# Ver estado do serviço
systemctl status libvirtd --no-pager

# Ver módulos KVM
lsmod | grep kvm

# Ver interfaces e endereços
ip -br address
```

------------------------------------------------------------------------

## Histórico e escopo

Este documento registra somente a preparação inicial do KVM/Libvirt no
host Ubuntu. A criação da VM Debian 13 será documentada em uma
etapa/tutorial separado, depois que a rede NAT for validada.

Relacionamento com a documentação do projeto:

-   **ADR:** decisões arquiteturais e justificativas.
-   **Journal:** sequência cronológica do trabalho, resultados e
    dificuldades.
-   **Tutorial:** procedimento reproduzível com comandos e validações.
-   **Roadmap:** etapas planejadas e seu estado.
