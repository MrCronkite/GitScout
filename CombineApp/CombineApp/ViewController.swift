//
//  ViewController.swift
//  CombineApp
//
//  Created by Admin on 25.07.24.
//

import UIKit

final class ViewController: UIViewController {

    private let ev = ExperementalView()

    let words = "a, an, the, I, you, he, she, it, we, they, me, him, her, us, them, my, your, his, our, their, be, have, do, say, go, get, make, know, think, take, see, come, want, look, use, find, give, tell, work, call, try, ask, need, feel, become, leave, put, keep, let, begin, seem, help, talk, turn, start, show, hear, play, run, move, live, believe, bring, write, read, speak, learn, study, eat, drink, sleep, walk, open, close, buy, sell, pay, meet, sit, stand, day, week, month, year, time, today, tomorrow, yesterday, morning, evening, night, minute, hour, man, woman, boy, girl, child, family, friend, people, person, name, home, house, room, school, student, teacher, job, company, office, food, water, coffee, tea, bread, milk, fruit, vegetable, meat, fish, egg, apple, banana, car, bus, train, plane, bike, road, street, city, country, shop, store, market, bank, hospital, hotel, restaurant, book, phone, computer, table, chair, door, window, key, bag, money, card, picture, music, movie, game, big, small, good, bad, new, old, young, happy, sad, easy, hard, fast, slow, hot, cold, beautiful, important, different, same, early, late, red, blue, green, black, white, yellow, brown, orange, pink, gray, one, two, three, four, five, six, seven, eight, nine, ten, first, last, more, less, many, few, all, some, any, every, no, yes, in, on, at, to, from, for, with, without, about, before, after, between, under, over, into, out, up, down, near, far, inside, outside, and, or, but, because, if, when, while, than, so, then, also, very, too, only, again, always, never, often, sometimes"

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await ev.start()
        }

        let publisher = (1...1000).publisher
        let subscriber = SlowSubscriber()

        publisher.subscribe(subscriber)

        print(
            words
                .split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .count
        )

    }
}
