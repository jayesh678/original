// import { Application } from "@hotwired/stimulus";

// const application = Application.start();

// // Configure Stimulus development experience
// application.debug = false;
// window.Stimulus = application;

// export { application };



$(document.body).on("click", ".digg_pagination a", function () {
  // window.location.reload();
setTimeout(function () {
    location.reload();
}, 100);
});
