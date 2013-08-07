import csv

MEN_PER_SAFF = 15

def read_file(file_name):
  """
  Parses data into a dict of taraweeh days (zero-indexed)

  ex. parsed_data[1] returns the second night of taraweeh, first day of ramadan.
  """
  with open(file_name, 'rb') as raw_data:
    reader = csv.reader(raw_data)
    parsed_data = {}
    for (i,row) in enumerate(reader):
      row = clean_row(row)
      parsed_data[i] = {
        'taraweeh_day'    : i,
        'taraweeh_date'   : row[0],
        'before_isha'     : float(row[1]) * MEN_PER_SAFF,
        'before_isha_ts'  : row[2],
        'before_1'        : float(row[3]) * MEN_PER_SAFF,
        'before_1_ts'     : row[4],
        'after_4'         : float(row[5]) * MEN_PER_SAFF,
        'after_4_ts'      : row[6],
        'after_8'         : float(row[7]) * MEN_PER_SAFF,
        'after_8_ts'      : row[8],
        'before_9'        : float(row[9]) * MEN_PER_SAFF,
        'before_9_ts'     : row[10],
        'after_12'        : float(row[11]) * MEN_PER_SAFF,
        'after_12_ts'     : row[12],
        'after_16'        : float(row[13]) * MEN_PER_SAFF,
        'after_16_ts'     : row[14],
        'after_20'        : float(row[15]) * MEN_PER_SAFF,
        'after_20_ts'     : row[16],
        'after_witr'      : float(row[17]) * MEN_PER_SAFF,
        'after_witr_ts'   : row[18],
      }
    return parsed_data

def clean_row(row):
  """Replace empty cells with 0 (for now)."""
  cleaned = []
  for data in row:
    if data == '':
      cleaned.append(0)
    else:
      cleaned.append(data)
  return cleaned

def get_num_days_gte(value, prayer_period, data):
  """
  Return the number of days where the attendance at a given prayer_period
  is greater than or equal to a given number.
  """
  count = 0
  for i in range(len(data)):
    if data[i][prayer_period] >= value:
      count += 1
  return count

def get_list_of_prayer_period_counts(prayer_period, data):
  counts = []
  for i in range(len(data)):
    num = data[i][prayer_period]
    counts.append(num)
  return counts

def get_list_of_prayer_period_count_deltas(prayer_period, data):
  deltas = []
  for i in range(len(data)-1):
    before = data[i][prayer_period]
    after = data[i+1][prayer_period]
    delta = after - before
    deltas.append(delta)
  return deltas

def get_entry_by_taraweeh_date(date, data):
  """
  Return the data entry for a specific D/MM/YYYY if found. None otherwise.
  """
  for i in range(len(data)):
    if data[i]['taraweeh_date'] == date:
      return data[i]
  return None

def time_elapsed(start, end):
  """
  Returns the number of minutes elapsed between two HH:MM:SS periods.
  This is purposfully non-robust because we don't have to compute times
  that cross over midnight (in this dataset at least).
  """
  start_frames = start.split(':')
  end_frames = end.split(':')
  start_minutes = int(start_frames[0]) * 60 + int(start_frames[1])
  end_minutes   = int(end_frames[0])   * 60 + int(end_frames[1])
  return end_minutes - start_minutes

def examples():
  """Examples of function calls."""
  data = read_file('Taraweeh Tracker - Abdasis.csv')
  print get_entry_by_taraweeh_date('7/9/2013', data)
  print get_num_days_gte(225, 'after_8', data)
  print time_elapsed('2:35:00', '3:50:00')
  print get_list_of_prayer_period_counts('before_9', data)
  print get_list_of_prayer_period_count_deltas('before_isha', data)

data = read_file('Taraweeh Tracker - Abdasis.csv')
print get_num_days_gte(225, 'after_8', data)