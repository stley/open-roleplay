new
    RequestsClient:LOG_CHANNEL,
    bool:isChannelWorking = true    
;
new webhook_url[256];
#define CURRENT_MODULE "discord-webhook"
#include "../gamemodes/modules/discord-webhook/discord-webhook_funcs.p"
#undef CURRENT_MODULE