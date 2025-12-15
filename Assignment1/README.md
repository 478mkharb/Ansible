## Assignment1 - UserManager
## Project Management System

### 1.Team Structure:
  - Create Development Team (dev)
  - Create DevOps Team (devops)
  - Create Admin Group (admin)
### Output

### Creating dev, devops and admin groups
![alt text](<Screenshots/Screenshot from 2025-12-15 12-50-02.png>)
![alt text](<Screenshots/Screenshot from 2025-12-15 12-55-49.png>)

### Advanced User Management:
  - Add 3 users to each team (total 9 users)
  - Each user must have custom UID starting from 2000
  - Set different login shells based on team role
  - Implement password policies with expiry

  ### 1. Creating Users of dev-Team
  - User_Name - dev1
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-02-36.png>)
  - User_Name - dev2
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-06-29.png>)
  - User_Name - dev3
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-07-28.png>)
  ### Listing users of dev-Team
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-37-18.png>)

  ### 2. Creating Users of devops-Team
  - User_Name - devops1
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-17-19.png>)
  - User_Name - devops2
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-20-02.png>) 
  - User_Name - devops3
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-21-17.png>)
 ### Listing users of devops-Team
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-39-41.png>)

 ### 3. Creating Users of admin-group
   - User_Name - admin1
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-45-47.png>)
   - User_Name - admin2
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-48-16.png>)
   - User_Name - admin3
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-49-28.png>)
  ### Listing users of admin-group
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-58-13.png>)

  ### 4. Assigning Full Sudo access to admin-group
  ![alt text](<Screenshots/Screenshot from 2025-12-15 13-52-53.png>)

  ### 5. Assigning partial sudo access to devops_Team for running systemctl commands only 
  ![alt text](<Screenshots/Screenshot from 2025-12-15 14-16-18.png>)
  
---

  ### Create Team Collaboration Directories

```bash
/home
    ├── dev
    ├── devops
    └── admin

/teams
    ├── dev
    └── devops

/projects
    ├── WebApp
    ├── API
    └── Mobile

/shared
    └── resources

/archive
    
```
  ### Creating /teams/dev directory with special permission 2775
  ![alt text](<Screenshots/Screenshot from 2025-12-15 14-21-33.png>)

  ### Creating /teams/devops directory with special permission 2775
  ![alt text](<Screenshots/Screenshot from 2025-12-15 14-54-20.png>)

---
  
  ### Creating /projects/WebApp directory with special permission 2775
  ![alt text](<Screenshots/Screenshot from 2025-12-15 15-03-27.png>)

  ### Creating /projects/API directory with special permission 2775
  ![alt text](<Screenshots/Screenshot from 2025-12-15 15-05-28.png>)

  ### Creating /projects/Mobile directory with special permission 2775
  ![alt text](<Screenshots/Screenshot from 2025-12-15 15-09-11.png>)

---
  ### Creating /SharedResources directory with special permission 2777
   ![alt text](<Screenshots/Screenshot from 2025-12-15 15-15-35.png>)

---

  ### Creating /archive directory with special permission 555
   ![alt text](<Screenshots/Screenshot from 2025-12-15 15-19-13.png>)

---

   ### Creating /admin directory with special permission 770
   ![alt text](<Screenshots/Screenshot from 2025-12-15 15-22-14.png>)