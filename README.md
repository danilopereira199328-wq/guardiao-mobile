# 📱 Guardião Mobile — app Android

App companheira do Guardião no PC. Faz o **bloqueio real de chamadas no telemóvel**
e envia mensagens recebidas para o servidor Guardião para análise de scam.

> Não precisa de Android Studio — veja as duas formas abaixo de obter o APK.

## Opção A — Compilar online com o GitHub Actions (recomendado, sem instalar nada)

O projeto inclui um fluxo de compilação automática
(`.github/workflows/build-apk.yml`):

1. Crie uma conta gratuita no [GitHub](https://github.com) (se não tiver).
2. Crie um repositório **privado** (ex.: `guardiao-mobile`).
3. Envie o **conteúdo desta pasta** para o repositório
   (a raiz do repositório deve conter `app/`, `build.gradle.kts`,
   `settings.gradle.kts` e a pasta `.github/workflows/`).
4. O GitHub compila sozinho: abra o separador **Actions** no repositório e,
   quando o build ficar verde, entre no job → secção **Artifacts** →
   descarregue `guardiao-mobile-apk` (zip com o `app-debug.apk`).
5. Passe o APK para o telemóvel (e-mail, cabo USB, Drive…) e instale
   (o Android pedirá autorizar "instalar de fontes desconhecidas").

Dica: pode também disparar um novo build manualmente em
**Actions → Build APK → Run workflow**.

## Opção B — Sem compilar nada: MacroDroid (automação no telemóvel)

Se não quiser instalar um APK próprio, a app gratuita
[MacroDroid](https://play.google.com/store/apps/details?id=com.arlosoft.macrodroid)
liga o telemóvel ao Guardião do PC com 2 macros:

**Macro 1 — Bloquear chamadas de scam**
1. Trigger: **Incoming Call** (Chamada recebida)
2. Ação: **HTTP GET Request** → `http://IP-DO-PC:8765/api/check?number={call_number}`
   (se tiver PIN, adicione `&pin=OSEUPIN` ao URL)
3. Guarde a resposta numa variável de texto
4. Ação: **If** variável contém `"block":true` → Ação **End Call** (rejeitar)

**Macro 2 — Enviar SMS recebidos ao Guardião**
1. Trigger: **SMS Received**
2. Ação: **HTTP POST Request** → `http://IP-DO-PC:8765/api/message`
   com o corpo `{"number":"{sms_number}","text":"{sms_body}"}`
   e header `Content-Type: application/json`
3. (Opcional) Ação **Show Toast** com a resposta

Requisitos: o PC com host `0.0.0.0` (Definições do Guardião) e ambos na mesma
rede Wi-Fi. A versão gratuita do MacroDroid permite até 5 macros.

## Opção C — Android Studio (se um dia instalar)

1. Abra esta pasta no Android Studio ("Open project").
2. `Build > Build APK(s)` → `app-debug.apk`.
3. Transfira para o telemóvel e instale.

## Configuração no telemóvel

1. Abra a app, escreva o endereço do servidor do PC
   (ex.: `http://192.168.1.100:8765` — veja o separador Definições do Guardião no PC)
   e o PIN, se tiver configurado um.
2. Toque em **Guardar e sincronizar** — descarrega a lista de bloqueio.
3. Toque em **Ativar bloqueio de chamadas** — o Android pede confirmação do papel
   *Call Screening* (a app passa a filtrar todas as chamadas recebidas).

## O que a app faz

| Componente | Função |
|---|---|
| `GuardiaoCallScreeningService` | Antes de cada chamada tocar, verifica a lista de bloqueio sincronizada e rejeita a chamada sem som nem notificação. Registra o bloqueio no servidor. |
| `SmsGuardReceiver` | Recebe SMS e envia o texto ao servidor para análise; se for scam, mostra um alerta no telemóvel e fica registado no histórico do PC. |
| `ServerSync` | HTTP puro (sem bibliotecas externas): sincroniza lista de bloqueio, envia chamadas/mensagens, mostra notificações locais. |

## Limitações do Android (importantes)

- **Bloqueio de chamadas**: totalmente suportado (Android 10+) via papel
  *Call Screening*. Só uma app pode ter esse papel de cada vez (desative outras
  apps tipo Truecaller se as tiver).
- **Bloqueio silencioso de SMS**: o Android só permite a apps que sejam a app de
  SMS **predefinida**. Esta app, por defeito, *deteta e alerta* sem bloquear.
  Para bloquear de verdade seria necessário implementar a app de SMS completa
  (caixa de entrada, envio) — posso fazer isso numa fase futura se quiseres.
- O telemóvel e o PC têm de estar na **mesma rede Wi-Fi** para sincronizar
  (o servidor tem de estar com `host = 0.0.0.0` nas Definições).
