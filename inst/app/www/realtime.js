Shiny.addCustomMessageHandler("supabaseConfig", function(config) {
  console.log("🔐 Supabase config reçue via Shiny");
  console.log("🔗 Connexion à Supabase WebSocket...");

  const supabase = window.supabase.createClient(config.url, config.key);

  supabase
    .channel('public:users')
    .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'users' }, payload => {
      console.log('💬 Event realtime:', payload);
      Shiny.setInputValue("user_update", payload, { priority: "event" });
    })
    .subscribe();
});

let timeout;
function resetTimer() {
  clearTimeout(timeout);
  timeout = setTimeout(function() {
    Shiny.setInputValue("user_inactive", true);
  }, 180000);
}

document.addEventListener("mousemove", resetTimer);
document.addEventListener("keydown", resetTimer);
document.addEventListener("click", resetTimer);
resetTimer();
