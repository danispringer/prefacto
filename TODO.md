# Known Bugs:
- [?] "Factorise" returns incorrect result sometimes, possibly depending on how quickly "Factor" is pressed after entering number.
- [?] Keyboard doesn't reopen after entering prime or non-prime number in checker (seems to exist in other views as well).

Found a bug? Let me know: [https://danispringer.github.io](https://danispringer.github.io)]

# Requested Features:

[no requested features. Is there a feature you'd like? Let me know: [https://danispringer.github.io](https://danispringer.github.io)]

---------------------------------------------------------------------------------------------------------------

# Developer notes:

- Replace alerts with views presented in alert navigation. Smaller than the parent view. With a tableview, scrollable, and done and share buttons
- Add about page with version, contact, review method
- Make modal like "prime-numbers-images-modal.PNG"
- Testa: hangs, correct responses, alerts, sharing per ogni pagina. fai lista.
- Add toolbar on top with share button always enabled. Check upon tap if there's what to share.
- Fix lag: dispatch practice.
- Aggiungi a descrizione store: app can handle multiple pages running simultaneusly.
- Migliora collectionview cells per riempire più spazio.
- Improve screenshots crop,
- Improve design.
- Add abort option.
- Return all the numbers by which a non-prime number can be divided, and their count.
- Minigame: tap the prime numbers. (collection view, reset on lives finished with alert, alert of lost life with alert or shake of tapped cell).
- SiriKit: "Hey Siri, does Primes Fun think 2341 is prime?".
- SiriKit: "Hey Siri, note the prime numbers between 1 and 50 using Primes Fun".
- GCF
- LCM
- Find next or previous primes
- Allow to copy to clipboard? Sharing already allows that?
- [?] Find prime by index
- [?] Find index by prime

---------------------------------------------------------------------------------------------------------------

[after significant change] redo screenshots, update description

---------------------------------------------------------------------------------------------------------------
# Refactor:
UICollectionView delegates could be put in a separate extension
https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Extensions.html#//apple_ref/doc/uid/TP40014097-CH24-ID151
~
[?] App store link https://itunes.apple.com/us/app/prime-numbers-fun/id1402417667

###### App Store Description
‘Primes Fun’ lets you:
• Check whether a number is prime
• List the prime numbers in a given range
• Factorize to primes any given number
• View fun images with prime numbers in them
• Share your results, like that huge prime number you found, which everyone must know about

Did you know? When running big calculations, you can navigate in between the app's different pages while they are loading, and come back to them later. Your initiated tasks won't be interrupted.

Get ‘Primes Fun’ today, and discover the fun!

Is there a feature you'd like to see? Leave a review!

Is there a bug you'd like to go away? Let us know: DaniSpringer.GitHub.io

##### Update

• This update brings some bug fixes.

• Found a bug you would like gone? Let us know: DaniSpringer.GitHub.io
• Love the app? Want a feature added? Leave a review!