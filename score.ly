\version "2.18.2"
\include "articulate.ly"
#(set-global-staff-size 16)

% TODO
% create midi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  http://lsr.di.unimi.it/LSR/Item?id=445

%LSR by Jay Anderson.
%modyfied by Simon Albrecht on March 2014.
%=> http://lilypond.1069038.n5.nabble.com/LSR-445-error-td160662.html

#(define (octave-up m t)
 (let* ((octave (1- t))
      (new-note (ly:music-deep-copy m))
      (new-pitch (ly:make-pitch
        octave
        (ly:pitch-notename (ly:music-property m 'pitch))
        (ly:pitch-alteration (ly:music-property m 'pitch)))))
  (set! (ly:music-property new-note 'pitch) new-pitch)
  new-note))

#(define (octavize-chord elements t)
 (cond ((null? elements) elements)
     ((eq? (ly:music-property (car elements) 'name) 'NoteEvent)
       (cons (car elements)
             (cons (octave-up (car elements) t)
                   (octavize-chord (cdr elements) t))))
     (else (cons (car elements) (octavize-chord (cdr elements ) t)))))

#(define (octavize music t)
 (if (eq? (ly:music-property music 'name) 'EventChord)
       (ly:music-set-property! music 'elements (octavize-chord
(ly:music-property music 'elements) t)))
 music)

makeOctaves = #(define-music-function (parser location arg mus) (integer? ly:music?)
 (music-map (lambda (x) (octavize x arg)) (event-chord-wrap! mus)))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cr = \change Staff = "right"
cl = \change Staff = "left"
rhMark = \markup { 
  \path #0.1 #'((moveto -1 0)(rlineto 0 -1.5)(rlineto 0.5 0))
}

\header {
  title = "Wii Sports Resort - Main Theme"
  subtitle = "For Piano Solo"
  arranger = "Arranged by Benson"
  composer = "Composed by Ryo Nagamatsu"
  copyright = "https://music.bensonby.me"
  tagline = "https://music.bensonby.me"
}

upper-prelude = \relative c {
  \clef bass
  g4\glissando
  \clef treble
  b'''4
  <c c,>1~ q8 c16\(-.-3 c-.-2 b-.-1 c8-. g16-. r g8-.-2 g16-.-1 g-.-4 f-. e-. c~ c1\)
  r8 g16\(-.-2 g-.-1 a-. c8-. g16-. r g-.-2 g-.-1 a-. c-. d-. e-. c-.\)
}

lower-prelude = \relative c' {
  r2
  << {
    <c \parenthesize e>8. <g c e>16~ q8 <g b d>~ q2
    <a c>8. <a c f>16~ q8 <g c e>~ q2
    <c \parenthesize e>8. <g c e>16~ q8 <g b d>~ q2
    <a c>8. <a c f>16~ q8 <g c e>
  } \\ {
    c,1 c c c2
  } >>
  \acciaccatura g'16 g,4 g''8\glissando g,,
}

% bar 5 - 16
upper-one = \relative c'' {
  \makeOctaves 1 {
    e2\( d d8.( e16) r8 f-. e4-- d--
    c8.( d16) r8 e-. d4-- a8-. c-. c8.( b16) r c8-. d16~-- d2\)
  }
  << {
    \stemNeutral
    <e e'>2\( <g g'>
    \override Script.padding = #2
    <a c a'>8.(-> <b f' b>16)-> r8 <c e c'>8~->\)
    \override Script.padding = #0.2
    q4 <c, c'>\(
    <f f'>8.( <e e'>16) r <d d'>8-. <c c'>16~ q4 <b b'>
    \stemUp
    <c c'>2\)
  } \\ {
    s1*3 c8.( <c, e g>16) r <g d' f>8-. <g c e>16-.
  } >>

  r16 e'\( fis gis b e, fis gis a8\)

  << {
    \stemNeutral
    g'8\( c16 d8 f16~ f8 e c g~ \stemUp g2\) s2
    \stemNeutral
    s8 g\( c16 d8 f16~ f8 e c g'~ \stemUp g2\)
  } \\ {
    s8 s2.
    r16 d,16\( b d r <d-3> <b-1> <d-3> \stemNeutral <a-1> <a-2> r <g-1> r b g a g8\)
    s8 s2.
    \stemDown
    r16 d'\( e c e d e <f-4> \stemNeutral <g-1>4\glissando g,4\)
  } >>
}

% bar 5 - 16
lower-one = \relative c, {
  c8. <g'-1>16 <g-2>4--
  c,8. g'16 g4--
  c,8. g'16 g4--
  c,8. g'16 gis4--
  a-- e-- fis-- d--
  g-- d-- b-- g--
  c8. c16 g'4--
  e8. e16 c4--
  <f f'>8.(-> <gis gis'>16)-> r8 <a a'>8~-> q8. e16 a,4
  d8. a'16 a4-- g-- g,--
  <f' a'>8.( <e g'>16) r16 <d f'>8-. <c e'>16-. r4 <b gis' b>4--
  <a a'>8. a16~ a8 a8 a'-. a,-. r16 a8.--
  g8. g16~ g8 g8 g'16-. g,8.-. <d' d'>4--
  \acciaccatura g,16 f8. f16 f'8-. f,-. r16 f8.-. <c' c'>4--
  e,8. c'16~ c8 e, r4 e'16 c <g g'>8--
}

% bar 17 - 29
upper-two = \relative c'' {
  \makeOctaves 1 {
    d8.\( e16~ e8 f~ f e4 f8 g8. c16~ c8 g~ g c,4.\)
  }
  << {
    f4.->\( g8~-> g4. gis8~-> gis4. ais8~-> ais4. b8->~\)\(
    b4. \stemNeutral gis16 e b8 e gis b ais4. fis16 cis ais2\)
  } \\ {
    <f aes des>8 <ees g ees'> <des f des'> <g bes ees>~
    q <des f des'> <ees g ees'> <gis b e>~
    q <dis fis dis'> <e gis e'> <ais cis fis>~
    q <e gis e'> <fis ais fis'> <b e gis>~
    q4.
  } >>
  a'4.\( fis16 d a8 d fis a
  <gis eis gis,>4-- <ais fisis ais,>-- <b gis b,>-- <cis ais cis,>\)--
  <b gis e>4.\( gis16 e b8 e gis b c4 \grace { c16 d e } <f f,>2 c4\)
  << {
    \stemNeutral
    <fis, dis fis,>8\( e16 fis <gis b, gis>8 fis16 gis
    <a e a,>8 gis16 a <b e, b>8 a16 b
    <c ees, c>8 bes16 c <d aes d,>8 c16 d
    <ees ges, ees>8 d16 ees <f c f,>8 ees16 f
    \stemUp
    <g d c g>2\)
  } \\ {
    s1*2 r4 g,,4^\mp \stemNeutral c g'
  } >>
}

% bar 17 - 29
lower-two = \relative c, {
  d8. a'16 a4--
  d,8. a'16 a4--
  e8. c'16 c4--
  e,8. c'16 c4--
  <des des,>8-> f aes <ees ees,>->~ q4 q8 <e e,>8->~
  q4 q8 <fis fis,>8->~ q4 q8 <a a,>8->

  a,,8. a'16~ a8 a-. a4-- a'8-. a,-.
  <gis gis'>8. gis16~ gis8 gis-. gis8. gis16 gis,4
  g'8. g16~ g8 g-. g4-- g'8 g,
  <dis cis'>4-- <eis dis'>-- <fis e'>-- <gis fis'>--
  a8. e'16 e8. e,16 a8. e'16 e4--
  g,8. d'16 d8. d,16 g8. d'16 d4--
  <e, b' e>4 <d d'> <cis cis'> <c c'>
  <bes ees bes'> <ees ees'> <aes, aes'> <des aes' des>
  <c c'>8. c16 g'4-- c,8. c16 g'8-. g-.
}

% bar 30 - 40
upper-three = \relative c'' {
  r8
  << {
    f8\( g16 a8. g8-. f-. e-. d-.\)
  } \\ {
    <a c>8-. r q-. r16 q16-. r8 q8-. q-.
  } >>
  r8
  << {
    d8\( e16 f8. e8-. d-. c-. b-.\)
  } \\ {
    <f b>8-. r q-. r16 <e gis>-. r8 q-. q-.
  } >>
  e'4 a, <f bes d> <e c' e>
  f'8-. c16( f~ f8 g) bes8-. a-. <f bes>-.
  << {
    c8--~ c4
    s2 \hideNotes c8
    \unHideNotes
    \clef treble
    \stemNeutral
    <c c'>8\(~^\f
    q8 <c c'>16 <bes bes'>~ q <aes aes'>8 <bes bes'>16~
    q8. <ees, ees'>16 <bes' bes'>8 <ees ees'>
    <ees ees'>8. <des des'>16~ q16 <ces ces'>8 <des des'>16~
    q8. <ges, ges'>16 <des' des'>8 <ges ges'>
    \stemUp
    <f f'>1\)
  } \\ {
    s8 r8 \clef bass
    \stemNeutral
    c,,8-. f16( a8) bes16~( bes8[ a)]
    \autoBeamOff
    \once \override Glissando.style = #'dashed-line
    f-.\glissando \cl c-.
    \autoBeamOn
    s1*2
    \cr \stemDown r8 <f' c'>8~-.^\p q16 q8-. q16~-. q q8.-. q8-. q-.
  } >>
  <f b>8-. q~-. q16 q8-. q16-.
  r4 r8
  << {
    \stemNeutral
    d''16\( e f8. e16~ e8 d c4 \grace { c16 d e f } \stemUp g4\)
  } \\ {
    s8 s2. r8 d,16\( e
    \stemNeutral
    f8. e16~ e8 d c4 g'\)
  } >>
}

% bar 30 - 40
lower-three = \relative c {
  a8( a') e,( e') d,( d') a( a')
  b,( b') f,( f') e,( e') b( b')
  a,( <a' c>) c,16( <a' c>8.) bes,,8 bes' c, c'
  bes8. f16~ f f, f'8-. bes,16 f'8. f,8-. f-.
  bes8. f'16~ f f, f'8-. bes,16 f'8. \stemDown f8-. f-.
  \stemNeutral
  aes8_( aes')
  aes16( ees aes,8) g8.( f'16 g ees g,8)
  ces8 <ges' ces ees>~-- q8. ces,16 bes8 <ges' bes des> <des des'> <bes bes'>
  <g g'>8. <d'-3>16 <d-2> g8. g16 g'8 g,16 d8-. d-.
  g8. d16-. d-. d8-. g16-.
  r4 g,,4->
  r2 r4 \repeat tremolo 2 { g16\p\< g' }
  \repeat tremolo 8 { g,16 g'\! }
}

% bar 41 - end
upper-end = \relative c'' {
  << {
    \grace { e32-2 f g a b }
    \stemUp
    <c, e c'>4
  } \\ {
    <c, e g>8. q16-.
  } >>
  r8 <d b g>8--~ q2
  <c f a>8. q16-. r8 <c e g>8--~ q4 e16( d c8)
  <c e g>8. q16-. r8 <d b g>8--~ q2
  <a' c f>8.-> q16~-> q8 <b d g>8-> r4 <g g'>
}

% bar 41 - end
lower-end = \relative c, {
  c4-- r r r8 r16 c-.
  c4-- r r2
  c4-- r r r8 r16 c-.
  a''8.-> a16~-> a8 g->
  g,,8. d'16 g4
}

upper = \relative c' {
  \set fingeringOrientations = #'(up)
  \clef treble
  \tempo 4 = 124
  \time 4/4
  \key c \major
  \partial 2
  \upper-prelude
  \repeat volta 2 {
    \upper-one
    \upper-two
    \upper-three
    \upper-end
  }
  % \bar "|."
}

lower = \relative c' {
  \set fingeringOrientations = #'(down)
  \clef bass
  \time 4/4
  \key c \major
  \partial 2
  \lower-prelude
  \repeat volta 2 {
    \lower-one
    \lower-two
    \lower-three
    \lower-end
  }
  \once \override Score.RehearsalMark.break-visibility = #end-of-line-visible
  \once \override Score.RehearsalMark.self-alignment-X = #RIGHT
  \once \override Score.RehearsalMark.direction = #DOWN
  \mark "Repeat and Fade, or end at middle of bar 12"
  % \bar "|."
}

dynamics = {
  s2\mf s1*4
  s1\mp s1*4 s2\< s2\! s1 s2 s16 s8.\mp s4
  s1*4
  s1\mf s1 s1\f s1
  s8. s16\mp s2. s1 s1 s2.\< s4\!
  s1*2
  s1_"cresc." s1 s1\f
  s1\mf s1*7 s2. s4\f s1*2 s1\mf s1*3
}

\book {
  \score {
    <<
      \new PianoStaff <<
        \new Staff = "right" {
          \set Staff.midiInstrument = #"acoustic grand"
          \set Staff.midiMinimumVolume = #0.6
          \set Staff.midiMaximumVolume = #0.7
          \articulate << \upper >>
        }
        \new Staff = "left" {
          \set Staff.midiInstrument = #"acoustic grand"
          \set Staff.midiMinimumVolume = #0.6
          \set Staff.midiMaximumVolume = #0.7
          \articulate << \lower >>
        }
      >>
    >>
    \midi {
    }
  }

  \score {
    \new StaffGroup <<
      \new PianoStaff <<
        \new Staff = "right" { \upper }
        \new Dynamics = "Dynamics_pf" \dynamics
        \new Staff = "left" { \lower }
      >>
    >>
    \layout {
    }
  }
}
