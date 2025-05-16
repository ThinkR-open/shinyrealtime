Shiny.addCustomMessageHandler("supabaseConfig", function(config) {
  console.log("🔐 Supabase config reçue via Shiny");
  console.log("🔗 Connexion à Supabase WebSocket...");

  const supabase = window.supabase.createClient(config.url, config.key);
  const userConnections = supabase.channel('public:userConnections')
  const iris = supabase.channel('public:userConnections')

  userConnections.on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'userConnections'
  }, payload => {
    console.log('➕ Nouvelle connexion ajoutée', payload);
    Shiny.setInputValue("user_connection_insert", payload, { priority: "event" });
  })

  userConnections.on('postgres_changes', {
    event: 'UPDATE',
    schema: 'public',
    table: 'userConnections'
  }, payload => {
   console.log('🖊️️ Connexion mise à jour', payload);
   Shiny.setInputValue("user_connection_update", payload, { priority: "event" });
  })

  iris.on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'iris'
  }, payload => {
   console.log('➕ Nouvelle ligne ajoutée', payload);
   Shiny.setInputValue("iris_insert", payload, { priority: "event" });
  })

  userConnections.subscribe();
  iris.subscribe();
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


Shiny.addCustomMessageHandler('closeOffcanvas', function(msg) {
  $(".offcanvas").offcanvas("hide")
});
