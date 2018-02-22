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
  g4
  \clef treble
  b'''4
  c1
}

lower-prelude = \relative c {
  r2
  c1
}

upper = \relative c' {
  \clef treble
  \tempo 4 = 124
  \time 4/4
  \key c \major
  \partial 2
  \upper-prelude
  \bar "|."
}

lower = \relative c' {
  \clef bass
  \time 4/4
  \key c \major
  \partial 2
  \lower-prelude
  \bar "|."
}

dynamics = {
  s1\f
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
