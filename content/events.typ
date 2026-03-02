// Event definitions module
// This file creates the events-state, defines the event function,
// and returns the state for use in index.typ

// Create a state to collect all events
#let events-state = state("events", ())

// Define the event function
#let event(title, date, listed_date: none, description: none, link: none) = {
  let event_data = (
    title: title,
    date: date,
    listed_date: if listed_date != none { listed_date } else { date },
    description: description,
    link: if link != none { link } else { "" }
  )

  // Add this event to the global state
  events-state.update(prev => prev + (event_data,))

  // Return nothing
  []
}

// Define all events
#event(
  "Noisy Systems: Aesthetics, Epistemology, and Computation",
  "2026-06-04",
  listed_date: "4–5 June 2026",
  description: [
    In machine learning and information theory, noise is typically defined as an unwanted intrusion into a signal—yet recent advances in large language and diffusion models place noise at the center of their operation.
  ],
  link: "https://www.biblhertz.it/3773193/260206_Noisy-Systems_-Aesthetics_-Epistemology_-and-Computation?c=2376430"
)

#event(
  "Call for Papers: Noisy Systems – Aesthetics, Epistemology, and Computation",
  "2026-03-16",
  listed_date: "16 March 2026",
  description: [
    Submission deadline (16 March 2026) for the Noisy Systems workshop, 4–5 June 2026, Bibliotheca Hertziana, Rome.
  ],
  link: "https://www.biblhertz.it/3773193/260206_Noisy-Systems_-Aesthetics_-Epistemology_-and-Computation?c=2376430"
)

// Export the state and event function for use in index.typ
#let exports = (
  events-state: events-state,
  event: event,
)
