import pandas as pd
import json

# Load JSON file
with open('/var/lib/jenkins/workspacemobsf_test/app.json') as f:
    data = json.load(f)

# Convert to DataFrame
df = pd.json_normalize(data)

# Save to Excel
df.to_excel('/var/lib/jenkins/workspacemobsf_test/app.xlsx', index=False)
