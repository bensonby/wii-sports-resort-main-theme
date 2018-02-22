\version "2.18.2"
\include "articulate.ly"
#(set-global-staff-size 15)

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
}

upper-prelude = \relative c {
  \clef bass
  g4\glissando
  \clef treble
  b'''4
  <c c,>1~ q8 c16\(-. c-. b-. c8-. g16 r g8-. g16-. g-. f-. e-. c~ c1\)
  r8 g16\(-. g-. a-. c8-. g16-. r g-. g-. a-. c-. d-. e-. c-.\)
}

lower-prelude = \relative c' {
  r2
  << {
    <c e>8. <g c e>16~ q8 <g b d>~ q2
    <a c>8. <a c f>16~ q8 <g c e>~ q2
    <c e>8. <g c e>16~ q8 <g b d>~ q2
    <a c>8. <a c f>16~ q8 <g c e>
  } \\ {
    c,1 c c c2
  } >>
  \acciaccatura g'16 g,4 g''8\glissando g,,
}

upper-one = \relative c'' {
  \makeOctaves 1 {
    e2\( d d8.( e16) r8 f-. e4 d
    c8.( d16) r8 e-. d4 a8 c c8.( b16) r c8-. d16~ d2\)
  }
  << {
    \stemNeutral
    <e e'>2\( <g g'> <a c a'>8.(-> <b f' b>16)-> r8 <c e c'>8~ q4 <c, c'>
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
    r16 d,16\( b d r d b d \stemNeutral a a r g r b g a g8\)
    s8 s2.
    \stemDown
    r16 d'\( e c e d e f \stemNeutral g4\glissando g,4\)
  } >>
}

lower-one = \relative c, {
  c8. g'16 g4--
  c,8. g'16 g4--
  c,8. g'16 g4--
  c,8. g'16 gis4--
  a-- e-- fis-- d--
  g-- d-- b-- g--
  c8. c16 g'4--
  e8. e16 c4--
  <f f'>8.(-> <gis gis'>16)-> r8 <a a'>8~-> q8. e16 a,4
  d8. a'16 a4-- g-- g,--
  <f' a'>8.( <e g'>16) r16 <d f'>8-. <c e'>16-. r4 <b gis' b>4
  <a a'>8. a16~ a8 a8 a'-. a,-. r16 a8.--
  g8. g16~ g8 g8 g'16 g,8. <d' d'>4--
  \acciaccatura g,16 f8. f16 f'8-. f,-. r16 f8. <c' c'>4--
  e,8. c'16~ c8 e, r4 e'16 c <g g'>8--
}

upper = \relative c' {
  \clef treble
  \tempo 4 = 124
  \time 4/4
  \key c \major
  \partial 2
  \upper-prelude
  \upper-one
  \bar "|."
}

lower = \relative c' {
  \clef bass
  \time 4/4
  \key c \major
  \partial 2
  \lower-prelude
  \lower-one
  \bar "|."
}

dynamics = {
  s1\mf
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
