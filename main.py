from __future__ import print_function
import datetime
import pickle
import os.path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import os
import re
import smtplib
import requests
import time
import speech_recognition as sr
import playsound
from gtts import gTTS
import pytz
import subprocess
from pyowm import OWM
import youtube_dl
import random

# If modifying these scopes, delete the file token.pickle.
SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']
MONTHS = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']
DAYS = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
DAY_EXTENSIONS = ["nd", "rd", "th", "st"]

def speak(text):
    tts = gTTS(text=text, lang="en")
    filename = "voice.mp3"
    tts.save(filename)
    playsound.playsound(filename)
    os.remove("voice.mp3")

def get_audio():
    r = sr.Recognizer()
    with sr.Microphone() as source:
        audio = r.listen(source, phrase_time_limit=2)
        said = ""

        try:
            said = r.recognize_google(audio)
            print(said)
        except Exception as e:
            print("Exception: " + str(e))

    return said.lower()

def authenticate_google():
    """Shows basic usage of the Google Calendar API.
    Prints the start and name of the next 10 events on the user's calendar.
    """
    creds = None
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('calendar', 'v3', credentials=creds)

    return service

def get_events(day, service):
    date = datetime.datetime.combine(day, datetime.datetime.min.time())
    end_date = datetime.datetime.combine(day, datetime.datetime.max.time())
    utc = pytz.UTC
    date = date.astimezone(utc)
    end_date = end_date.astimezone(utc)

    events_result = service.events().list(calendarId='primary', timeMin=date.isoformat(),
                                          timeMax=end_date.isoformat(), singleEvents=True,
                                        orderBy='startTime').execute()
    events = events_result.get('items', [])

    if not events:
        speak('No upcoming events found.')
    else:
        speak(f"you have {len(events)} on this day.")
        for event in events:
            start = event['start'].get('dateTime', event['start'].get('date'))
            print(start, event['summary'])
            start_time = str(start.split("T")[1].split("+")[0])
            if int(start_time.split(":")[0]) < 12:
                start_time = start_time + "am"
            else:
                start_time = str(int(start_time.split(":")[0])-12) + start_time.split(":")[1]
                start_time = start_time + "pm"

            speak(event["summary"] + "at" + start_time)

def get_date(text):
    text = text.lower()
    today = datetime.date.today()

    if text.count("today") > 0:
        return today

    day = -1
    day_of_week = -1
    month = -1
    year = today.year

    for word in text.split():
        if word in MONTHS:
            month = MONTHS.index(word) + 1
        elif word in DAYS:
            day_of_week = DAYS.index(word)
        elif word.isdigit():
            day = int(word)
        else:
            for ext in DAY_EXTENSIONS:
                found = word.find(ext)
                if found > 0:
                    try:
                        day = int(word[:found])
                    except:
                        pass
    if month < today.month and month != -1:
        year = year+1

    if day < today.day and month == -1 and day != -1:
        month = month + 1

    if month == -1 and day == -1 and day_of_week != -1:
        current_day_of_week = today.weekday()
        dif = day_of_week - current_day_of_week

        if dif < 0:
            dif += 7
            if text.count("next" or "upper") >= 1:
                dif += 7

        return today + datetime.timedelta(dif)

    if month == -1 or day == -1:
        return None

    return datetime.date(month=month, day=day, year=year)

def note(text):
    date = datetime.datetime.now()
    file_name = str(date).replace(":", "-") + "-note.txt"
    with open(file_name, "w") as f:
        f.write(text)

    subprocess.Popen(["notepad.exe", file_name])

'''def song(music):

    comand = 'C:/Program Files/VideoLAN/VLC/vlc.exe', 'C:/Users/okunato oluwanifemi/Music/Marry Me.mp3'
    subprocess.Popen(comand, shell = True)'''

WAKE = "sandra"
SERVICE = authenticate_google()
print("start")

while True:
    speak("listening")
    text = get_audio()

    if text.count(WAKE) > 0:
        speak("what can i do for you?")
        text = get_audio()

        CALENDAR_STRS = ["what do i have", "do i have plans", "am i busy", "what are my plans"]
        for phrase in CALENDAR_STRS:
            if phrase in text:
                date = get_date(text)
                if date:
                    get_events(date, SERVICE)
                else:
                    speak("nothing sir")

        NOTE_STRS = ["open a notepad", "open notepad", "make a note", "write this down", "remember this"]
        for phrase in NOTE_STRS:
            if phrase in text:
                speak("What would you like me to write?")
                note_text = get_audio()
                note(note_text)
                speak("Note has been written")

        SONG_STRS = ["play me a song", "music", "song", "vlc", "mp3"]
        for phrase in SONG_STRS:
            if phrase in text:
                speak("ok sir, enjoy")
                music_dir = r"C:/Users/okunato oluwanifemi/Music"
                song = random.choice(os.listdir(music_dir))
                print(song)
                os.startfile(music_dir + '\\' + song)
                exit()

        GIST_STR = ["let's talk", "i am tired", "why are you like this?"]
        for phrase in GIST_STR:
            if phrase in text:
                speak("leave me alone, i don't want to know about your troubles")
                gist_text = get_audio()
                if "what are you feeling like" in gist_text:
                    speak("nifair i am done with you. bye-bye")

        QUIT_STRS = ["bye bye", "stop", "shutdown", "quit", "close program"]
        for phrase in QUIT_STRS:
            if phrase in text:
                exit()

        '''VLC_song = ["play me a song", "music", "song", "vlc"]
        path = 'C:/Users/okunato oluwanifemi/Music/Marry Me.mp3'
        folder = path
        for d_file in os.listdir(folder):
            path_file = os.path.join(folder, d_file)
            try:
                if os.path.isfile(path_file):
                    os.unlink(path_file)'''
