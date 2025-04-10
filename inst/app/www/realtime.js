Shiny.addCustomMessageHandler("supabaseConfig", function(config) {
  console.log("🔐 Supabase config reçue via Shiny");
  console.log("🔗 Connexion à Supabase WebSocket...");

  const supabase = window.supabase.createClient(config.url, config.key);
  const channel = supabase.channel('public:userConnections')

  channel.on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'userConnections'
  }, payload => {
    console.log('➕ Nouvelle connexion ajoutée', payload);
    Shiny.setInputValue("user_connection_insert", payload, { priority: "event" });
  })

  channel.on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'userConnections'
  }, payload => {
   console.log('🖊️️ Connexion mise à jour', payload);
   Shiny.setInputValue("user_connection_update", payload, { priority: "event" });
  })

  channel.subscribe();
});

let timeout;
function resetTimer() {

  clearTimeout(timeout);
  console.log("🕒 Timer réinitialisé");

  timeout = setTimeout(function() {
    console.log("🕒 Timer expiré, utilisateur inactif");
    Shiny.setInputValue("user_inactive", true, { priority: "event" });
  }, 30000);
}

document.addEventListener("mousemove", resetTimer);
document.addEventListener("keydown", resetTimer);
document.addEventListener("click", resetTimer);
resetTimer();
