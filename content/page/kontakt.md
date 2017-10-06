---
title: "Kontakt"
description: "Strona kontaktowa"
menu: main
weight: -180
---

<form name="contact" action="thank-you" netlify>
  <p class="hidden">
    <label>Proszę NIE wypełniać: <input name="bot-field"></label>
  </p>
  <p>
    <label>Twoje Imię: <input type="text" name="name"></label>
  </p>
  <p>
    <label>E-mail: <input type="email" name="email"></label>
  </p>
  <p>
    <label>Treść wiadomości: <textarea name="message"></textarea></label>
  </p>
  <p>
    <button type="submit">Wyślij</button>
  </p>
</form>
