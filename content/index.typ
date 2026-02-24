#let template(current-page: none, doc) = {
  doc
}

#let default-image = "https://content.fitz.ms/fitz-website/assets/impett_leonardo.jpeg"

#let person(name, affiliation-period: none, image: none, body) = {
  let img-src = if image != none { image } else { default-image }
  let period = if affiliation-period != none and type(affiliation-period) == str {
    affiliation-period.replace(" -- ", " \u{2013} ")
  } else {
    affiliation-period
  }
  context if target() == "html" {
    html.elem("div", attrs: (class: "person"))[
      #html.elem("img", attrs: (src: img-src, alt: name))
      #html.elem("div")[
        #if period != none [
          *#period: #name*\
          #body
        ] else [
          *#name*\
          #body
        ]
      ]
    ]
  } else {
    if period != none [
      *#period: #name*\
      #body
    ] else [
      *#name*\
      #body
    ]
  }
}

#show: template.with(current-page: "index")

= Machine Visual Culture Research Group

This is a small, unofficial page for the research group, which is divided between two institutions (each with their own institutional websites):

#context if target() == "html" {
  html.elem("ul", attrs: (class: "institutions"))[
    #html.elem("li")[#link("https://www.biblhertz.it/machine-visual-culture")[Bibliotheca Hertziana -- Max Planck Institute for Art History, Rome]]
    #html.elem("li")[#link("https://www.cdh.cam.ac.uk/")[Cambridge Digital Humanities]]
  ]
}

== About

The Machine Visual Culture research group investigates the reciprocal relationship between artificial intelligence and visual culture, focusing on how AI (Artificial Intelligence) systems both shape and are shaped by histories of seeing.
Combining digital art history with critical AI studies, the group explores AI not only as a technological tool but also as a cultural phenomenon with important implications for the humanities.

Our research project has two central axes.
First, it situates AI within art history, examining how neural networks and other AI technologies encode cultural assumptions, visual ideologies, and epistemological frameworks.
This includes studying the biases and representational practices embedded in AI training datasets and neural architectures, as well as the broader historical and theoretical contexts that underpin these systems.
Second, the project develops and applies AI techniques to investigate the history of art and visual culture at new levels of scale and complexity: opening up new practical and theoretical avenues for art historical research while critically examining the assumptions and epistemologies embedded in these technologies.

By bridging these two perspectives, Machine Visual Culture offers an interdisciplinary approach that positions AI as both a subject of cultural critique and a transformative approach to art historical research, documenting a pivotal moment in the cultural history of AI.

The group runs parallel nodes in *Rome* (Bibliotheca Hertziana) and *Cambridge* (Cambridge Digital Humanities), hosting visiting researchers, artists, postdocs, and doctoral students.

More information here: #link("https://www.biblhertz.it/en/machine-visual-culture")[https://www.biblhertz.it/en/machine-visual-culture]

#context if target() == "html" { html.elem("hr") }

= People

#context if target() == "html" { html.elem("hr") }

== Rome Node

=== PI

#person(
  "Leonardo Impett",
  image: "https://content.fitz.ms/fitz-website/assets/impett_leonardo.jpeg",
)[
  Research Group Leader (Bibliotheca Hertziana) and Assistant Professor (Cambridge Digital Humanities).
]

=== PhD fellows

#person("Sebastian Rozenberg (Linköping)", affiliation-period: "September 2025 -- March 2026")[
  Sebastian Rozenberg is a PhD candidate at Linköping University working in media aesthetics and digital visual culture.
]

#person(
  "Tristan Dot (Cambridge)",
  affiliation-period: "September -- December 2025",
  image: "https://www.gatescambridge.org/wp-content/uploads/2022/09/dot-scaled.jpg",
)[
  Tristan Dot is a PhD candidate in Digital Art History at the University of Cambridge, researching nineteenth-century textile patterns and the epistemology of digital art history.
]

#person("Ellen Charlesworth (Durham)", affiliation-period: "October -- December 2025")[
  Ellen Charlesworth is an AHRC-funded PhD researcher at Durham University whose work examines how museums use digital platforms and how algorithmic infrastructures shape public access to cultural content.
]

#person("Angel Fernandez (Malaga)", affiliation-period: "January -- March 2026")[
  To be added.
]

=== Visitors

#person("Dominik Bönisch (Düsseldorf)", affiliation-period: "October 2025")[
  Dominik Bönisch is a researcher at MIREVI, Düsseldorf, working on AI-based archiving, museum collections, and algorithmic mediation in cultural heritage.
]

#person("Silvia Garzarella (Bologna / Utrecht)", affiliation-period: "November 2025")[
  Silvia Garzarella is a PhD candidate at the University of Bologna studying the remediation of intangible dance heritage, with a focus on the choreographic and archival afterlives of Rudolf Nureyev.
]

=== Postdocs

#person("Violaine Boutet de Monvel", affiliation-period: "September 2025 -- September 2026")[
  Violaine Boutet de Monvel works on noise and recursivity in art and media, from video feedback systems to generative AI, drawing on contemporary art theory and media studies.
]

#person("Amira Moeding", affiliation-period: "April 2026 -- April 2027")[
  Amira Moeding works on the intellectual history of computation, from early computational linguistics to contemporary AI, with interests in epistemic change in data-driven research cultures.
]

#context if target() == "html" { html.elem("hr") }

= Cambridge Node

=== Visitors

#person("Marta Pizzagalli (Lugano)", affiliation-period: "September 2025 -- March 2026")[
  Marta Pizzagalli is a PhD researcher at USI Lugano working on comparative literature, intermediality, and the visual apparatuses embedded in literary texts.
]

*Past Visitors:* Adrien Jeanrenaud (Geneva), Ludovica Schaerf (Zürich)

=== PhD Students

#person(
  "Tristan Dot",
  affiliation-period: "2022 -- 2026",
  image: "https://www.gatescambridge.org/wp-content/uploads/2022/09/dot-scaled.jpg",
)[
  (See above)
]

#person("Alessandro Trevisan", affiliation-period: "2023 -- 2027")[
  Alessandro Trevisan works on the philosophy of language in LLMs, including multimodality and vision, especially in dialogue with Wittgenstein.
]

#person(
  "Emmanuel Iduma",
  affiliation-period: "2024 -- 2028",
  image: "https://civi.gatescambridge.org/sites/www.gatescambridge.org/files/civicrm/persist/contribute/images/1000087701.jpg",
)[
  Emmanuel Iduma is a writer, art critic and Gates Scholar.
  His research looks at Nigerian conflict photojournalism through the lens of distant viewing.
]

#person(
  "Eryk Salvaggio",
  affiliation-period: "2025 -- 2029",
  image: "https://civi.gatescambridge.org/civicrm/contact/imagefile?photo=Eryk_Salvaggio3574_7ac4b7b975e13b3e71d9cff06dcb9d7d.jpg",
)[
  Eryk Salvaggio is a media artist and Gates Scholar studying generative AI from a digital-humanities perspective, focusing on archives, media ecologies, and critical data studies.
]

#context if target() == "html" { html.elem("hr") }

= Publications and Outputs

- Forthcoming: _Vector Media_ (Meson Press, 2025) by Leonardo Impett and Fabian Offert

#context if target() == "html" { html.elem("hr") }

= Events and News

- Upcoming and past visitors
- Workshops and internal seminars
- Conference presentations
- Public lectures and exhibitions

#context if target() == "html" { html.elem("hr") }

= Contact

If you really must
