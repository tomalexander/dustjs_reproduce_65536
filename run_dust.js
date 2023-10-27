// var dust = require("dustjs-linkedin");
var dust = require("dustjs-helpers");
var fs = require("fs");

const argv = process.argv.slice(2);
const context = JSON.parse(fs.readFileSync(argv[0], "utf-8"));
const template = fs.readFileSync(argv[1], "utf-8");
const compiled_template = dust.compile(template, "main");
dust.loadSource(compiled_template);
dust.render("main", context, function(err, out) {
  if(err) {
    console.error(err);
    process.exit(1);
  } else {
    console.log(out);
    process.exit(0);
  }
});
