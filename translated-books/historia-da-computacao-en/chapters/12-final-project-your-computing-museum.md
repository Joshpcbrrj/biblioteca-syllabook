# 12. Final project: your computing museum

> 🗺️ **In this chapter:** you build an annotated timeline of 15 milestones in computing, with one cause for each turning point and one myth checked against a source, and you decide who gets in and who is left out. · ⏱️ ~60 min

> 🔥 **Warm-up:** (1) What did the Transformer dispense with, according to the 2017 paper? (2) What is Law 7,232 of 1984, and what kind of protection did it give?
>
> <details>
> <summary>See answers</summary>
>
> (1) Recurrence and convolutions: the model is based on attention alone. (2) The National Informatics Policy: transitory protection for domestic companies, preference in public purchasing and import control for 8 years. (My translation of the Portuguese text.)
>
> </details>

## Where we left off

In chapters 1 to 11 you covered more than two centuries, from the Jacquard loom to language models. Now the work is yours. **The guiding question is: which 15 milestones would you choose to tell this story, and what explains each turning point between them?** The chapter shows a sample museum, and you build your own in practice.

## Choosing milestones

A list of dates is not a story. A good milestone is an event with a date, a name and a source that you can explain in two sentences, and that changes what people could do.

**A milestone is a dated event, with a source, after which something became possible that was not possible before.**

Each milestone in the project has five fields: year, name, country, cause and the chapter of the book where it appears. The sample museum below uses only milestones that the book has already presented with a source. Yours can choose others, as long as you open the source of each one before stating it.

```python
# Museum checker: each milestone is (year, name, country, cause, chapter)
milestones = [
    (1801, "Jacquard loom", "FR", "change the pattern without rebuilding", 1),
    (1890, "Hollerith census", "US", "manual counting too slow", 3),
    (1936, "Turing machine", "GB", "define what computing is", 4),
    (1945, "Stored program", "US", "instructions and data in memory", 6),
    (1947, "Transistor", "US", "replace the tube with a solid switch", 7),
    (1961, "Zezinho at ITA", "BR", "have a machine to teach with", 6),
    (1964, "System/360", "US", "same programming across 5 models", 7),
    (1969, "ARPANET", "US", "connect machines with packets", 10),
    (1971, "Intel 4004", "US", "processor on a single chip", 7),
    (1972, "Patinho Feio", "BR", "a computer of our own in Brazil", 7),
    (1975, "Altair 8800", "US", "cheap chips become a kit", 9),
    (1984, "Law 7,232", "BR", "protect domestic companies", 9),
    (1989, "AlterNex", "BR", "a network outside academia", 10),
    (1991, "Web at CERN", "CH", "link documents with hyperlinks", 10),
    (2022, "ChatGPT", "US", "models that converse", 11),
]
errors = []
if len(milestones) < 15:
    errors.append(f"missing milestones: {len(milestones)} of 15")
br = [m for m in milestones if m[2] == "BR"]
if len(br) < 2:
    errors.append("fewer than 2 Brazilian milestones")
if [m[0] for m in milestones] != sorted(m[0] for m in milestones):
    errors.append("out of order")
for year, name, _, cause, chap in milestones:
    if not cause.strip():
        errors.append(f"{name}: no cause")
print(f"{len(milestones)} milestones, {len(br)} Brazilian")
for (a, n, *_), (b, m, *_) in zip(milestones, milestones[1:]):
    print(f"{a} -> {b} (+{b - a:>3}): {n} -> {m}")
print("Errors:", errors or "none")
```

Real output, run while writing the chapter:

```text
15 milestones, 4 Brazilian
1801 -> 1890 (+ 89): Jacquard loom -> Hollerith census
1890 -> 1936 (+ 46): Hollerith census -> Turing machine
1936 -> 1945 (+  9): Turing machine -> Stored program
1945 -> 1947 (+  2): Stored program -> Transistor
1947 -> 1961 (+ 14): Transistor -> Zezinho at ITA
1961 -> 1964 (+  3): Zezinho at ITA -> System/360
1964 -> 1969 (+  5): System/360 -> ARPANET
1969 -> 1971 (+  2): ARPANET -> Intel 4004
1971 -> 1972 (+  1): Intel 4004 -> Patinho Feio
1972 -> 1975 (+  3): Patinho Feio -> Altair 8800
1975 -> 1984 (+  9): Altair 8800 -> Law 7,232
1984 -> 1989 (+  5): Law 7,232 -> AlterNex
1989 -> 1991 (+  2): AlterNex -> Web at CERN
1991 -> 2022 (+ 31): Web at CERN -> ChatGPT
Errors: none
```

Check: 2022 − 1991 = 31; 1991 − 1989 = 2; from 1801 to 2022 is 221 years. ✔ The gaps show only what this museum chose to list. They are not the pace of history, and two milestones close in time (such as 1971 and 1972) do not prove that one caused the other.

**Common mistake:** bunching the milestones into a single era. The 15 in the sample cover two centuries; if yours all fall after 1970, you are telling only part of the story.

## Cause and effect

Each milestone in the museum has to answer: **what did people want to solve?** That is the cause. The timeline becomes a story when you link each turning point to the next with that question.

**Cause, here, is the problem someone wanted to solve; effect is what became possible afterwards.**

An example from what the book has already shown: in the 1890 census there were 63 million people, and the estimate was that the manual method would not finish in time (chapter 3). The cause is that too-slow counting; the effect is the contest that Hollerith won, with cards and a tabulating machine.

> 💡 **Analogy: the recipe.** A milestone is a new dish; the cause is the hunger or the lack that led the cook to invent it. **Where the analogy breaks:** in real history, the "cook" is often a group, a company or a government, and the dish does not always come out (the Analytical Engine was never completed).

Two traps when writing the cause. First, it has to come from a source, not from your imagination: if the book does not say why something was done, write "cause not verified" instead of inventing one. Second, almost no turning point has a single cause; choose the one the source highlights and say that there are others.

**Common mistake:** writing "because it was inevitable". That is not a cause. A cause is a concrete problem, with a date and people involved.

## Checking a legend

Every museum has legends at the entrance. Your project requires you to check one, with a source, using the book's method: **fact vs. interpretation vs. legend**.

**A legend is a story repeated as fact that the source does not support, or supports only in part.**

Worked example, the "first bug" (chapter 8):

- **Fact:** the 1947 moth existed.
- **Legend:** that it was the origin of the word "bug". According to JSTOR Daily, the word was already in use before: in 1878 by Edison and in 1889 by a newspaper.
- **How you checked:** you opened the source, noted the dates and compared them with the story that circulates.

Other legends the book has already dealt with: the "first programmer" (Note G is a fact; the title is debated, chapter 2) and the "first computer" (it depends on the definition used, chapter 5).

> ⚖️ **Fact vs. interpretation vs. legend.**
> **Fact:** the 1947 moth existed, and the word "bug" already had earlier records (1878 and 1889).
> **Interpretation:** whether the 1947 episode still deserves to be told as a curiosity, as long as it is told without the "first".
> **Legend to avoid:** "that is where the word bug was born".

**Common mistake:** thinking that checking a legend is merely saying "it's a lie". Most have a true part, and your job is to separate the part the source supports from the part it does not.

## Who was left out

Every museum of 15 milestones leaves people out, and that is also a choice. The sample above has only machines, laws and networks. But the chapters showed who was behind them: the human computers at Langley, a team of women (chapter 3); the six ENIAC programmers, who programmed the machine with wires and switches (chapter 5); Grace Hopper and the A-0 compiler of 1952, and Margaret Hamilton, who led the Apollo flight software (chapter 8).

When you build your museum, write a note of two or three lines: who or what was left out, and why. It does not count to say "it didn't fit" without pointing to what you cut instead.

**Common mistake:** trying to make up for an absence with a list of names with no cause. A name with no associated turning point becomes decoration; link each person to the milestone in which they took part.

## At least 2 Brazilian milestones

The history of computing was not made only in other countries. The project requires at least two Brazilian milestones, and the sample's checker verifies that. The sample includes four, all with a source in chapters 6, 7, 9 and 10: Zezinho at ITA (1961), the Patinho Feio at Poli-USP (1972), Law 7,232 (1984) and AlterNex (1989).

Each has its own place in the story. Law 7,232 gave transitory protection to domestic companies for 8 years, and AlterNex took the network outside RNP's academic circuit. Compare with the rest of the world only with a source: the book does not claim that a Brazilian milestone "answered" a foreign one only because the dates are close.

**Common mistake:** treating Brazil as a footnote or, the other way round, saying that a Brazilian milestone was "the first in the world" without a source. Stick to what the sources say: what was done, when and by whom.

## 🏋️ Practice

**1. Worked example.** Pick a milestone from the sample museum and write its cause in one sentence, with the source.

- Milestone: System/360 (1964).
- Cause: offering five models with the same programming (chapter 7).
- Source: chapter 7 and the source cited in it. ✔

**2. Complete it.** Link each milestone to its cause: Altair 8800 → ___; AlterNex → ___; Transistor → ___.

<details>
<summary>See answer</summary>

Altair 8800: cheap chips made a computer in a kit possible. AlterNex: taking the network outside academia. Transistor: replacing the tube with a solid switch. Common mistake: writing only the effect as the cause ("it became a personal computer").

</details>

**3. On your own.** Build your museum: 15 milestones with year, name, country, cause and chapter, at least 2 Brazilian, in chronological order. Run the chapter's checker with your list; it should print "Errors: none".

<details>
<summary>See answer</summary>

Open answer. Check it against this rubric: (1) there are 15 milestones and at least 2 are Brazilian; (2) they are in order; (3) each has a cause that is a problem, not only an effect; (4) each claim comes from a source you opened.

</details>

**4. Challenge (checking a legend).** Pick a legend about computing that you have heard and that is not in this book. In 5 to 8 lines: (a) tell the legend; (b) separate fact, interpretation and legend; (c) cite the source you opened and say who wrote it and when.

<details>
<summary>See answer</summary>

Open answer. Check it against this rubric: (1) the legend is stated clearly; (2) the part supported by the source is separated from the part that is not; (3) the source has an author and a date, and you said what it can and cannot prove; (4) you did not conclude more than the source allows.

</details>

## 🧠 Quick review

1. What does a milestone need in order to enter the museum?
2. What is a "cause" in this project?
3. What are the three layers for checking a legend?
4. Why does the checker not prove that one milestone caused another?
5. (From chapter 5) Why does "first computer" depend on the definition?

<details>
<summary>See answers</summary>

1. A year, a name, a source and a cause. 2. The problem someone wanted to solve. 3. Fact, interpretation and legend. 4. It checks only the list (quantity, order, causes filled in), not the truth of each cause. 5. Because each machine meets part of the definition, and the answer changes with the definition chosen.

</details>

## 🤖 Study with an AI tutor

- "Read my museum of 15 milestones and, one question at a time, ask me the cause of each turning point. Do not give me the answer before I try."
- "Here is the legend I chose and my check: [text]. Point out where I mixed fact and interpretation, without rewriting it for me, and remind me to check the source."

> ➡️ **Next:** you have finished the book's path. See the suggested further reading at the end.

## 📌 Summary

| Item | In one sentence |
| --- | --- |
| Milestone | A dated event, with a source, after which something became possible. |
| Cause | The problem someone wanted to solve, with a source. |
| Legend | A story repeated as fact that the source does not support, or supports in part. |
| Who was left out | A 2–3 line note on what the museum set aside and why. |
| Brazilian milestones | At least 2 in the museum, with a source, with no "delay" and no "miracle". |

## 📚 Sources

- This chapter brings no new facts: the milestones come from the sources listed in chapters 1 to 11.
- JSTOR Daily, [The Bug in the Computer Bug Story](https://daily.jstor.org/the-bug-in-the-computer-bug-story), checked on 11/27/2026.
- Computer History Museum, [Ada Lovelace](https://www.computerhistory.org/babbage/adalovelace/), checked on 11/27/2026, and Prospect, [Debugging the mythology](https://prospectmagazine.co.uk/ideas/technology/38160/debugging-the-mythology-was-ada-lovelace-really-the-first-computer-programmer), checked on 11/27/2026.

> 🔁 **Review today:** chapters 5, 9 and 11

<!-- next-steps:start -->
## 🧭 Next steps

- **How a computer works inside**: To understand in practice the bits, logic and memory this book introduced through history (logic gates · binary · CPU and memory)
- **History of the internet and digital culture**: To go deeper into networks, the web, social networks and their effects on society (protocols · web 2.0 · privacy)
- **AI for the curious**: To understand how today's AIs work and how to use them with judgment (machine learning · language models · limits and risks)
<!-- next-steps:end -->

<!-- nav:start -->
---

[◀ Previous chapter](11-machines-that-learn-the-long-road-of-artificial.md) · [Book map](../README.md) · [Next chapter ▶](13-final-mock-exam.md)
<!-- nav:end -->
