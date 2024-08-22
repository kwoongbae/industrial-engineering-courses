# include <stdio.h>
# include <string.h>
# define DLLImport __declspec(dllimport)

// ******* Structures
struct Customer {
	char name[10];
	char date_of_birth[10];
	int age;
	char citizenship_number[10];
	char address[50];
	char phone_number[15];
	char account_number[20];
	int amount_to_deposit;
	char type_of_deposit[20];
	int interest;
};

// ******* Enums
typedef enum _Amount_type {
	saving = 1, current, fixed_for_1years, fixed_for_2years, fixed_for_3years
};

void menu();
void create_new_account(FILE* fp, int number_of_customers, struct Customer* c);
void update_existing_account(FILE* fp, int number_of_customers, struct Customer* c);
void transaction(FILE* fp, int number_of_customers, struct Customer* c);
void check_the_details(int number_of_customers, struct Customer* c);
void remove_existing_account(FILE* fp, int number_of_customers, struct Customer* c);
void view_customer_list(int number_of_customers, struct Customer* c);

int main() {
	// ******* Pointer
	FILE* fp = NULL;

	int choice = 0;
	int number_of_customers = 0;
	printf("How many customers will you enter? : ");
	scanf_s("%d", &number_of_customers);
	printf("There are spaces for %d customers in txt file\n\n", number_of_customers);
	
	// ******* Pointer
	struct Customer* c;

	// ******* Dynamic memory allocation
	c = (struct Customer*)malloc(sizeof(struct Customer) * number_of_customers);

	// ******* While Loop
	while (choice !=7) {
		menu();
		scanf_s("%d", &choice);
		// ******* switch statements
		switch (choice) {
			// ******* Functions by reference
		case 1: create_new_account(fp, number_of_customers, c);  break;
		case 2: update_existing_account(fp, number_of_customers, c); break;
		case 3: transaction(fp, number_of_customers, c); break;
		case 4: check_the_details(number_of_customers, c); break;
		case 5: remove_existing_account(fp, number_of_customers, c); break;
		case 6: view_customer_list( number_of_customers, c); break;
		case 7: 
			printf("Exit"); 
			// ******* all memory are freed
			free(c); 
			break;
		}
	}

	return 0;
}

//1. menu : 어떤 함수를 실행할 것인지 안내
void menu() {
	printf("BANKING MANAGEMENT SYSTEM \n");
	printf("*********************************** \n");
	printf("1. Create new account \n");
	printf("2. Update existing account \n");
	printf("3. Transaction \n");
	printf("4. Check the details of existing account \n");
	printf("5. Removing existing account \n");
	printf("6. View customer's list\n");
	printf("7. Exit\n");
	printf("*********************************** \n");
	printf("\n");
	printf("Enter your choice :");
}

// 2. create_new_account : 정보를 입력한다.
void create_new_account(FILE* fp, int number_of_customers, struct Customer *c) {
// name, age, date of birth, citizenship number, address ,phone number, account number, amount to deposit, amount_type, interest

	// **** File handling
	fp = fopen("D:\\datis.txt", "w");

	char name[10] = { 0, };
	int age = 0;
	char date_of_birth[10] = { 0, };
	char citizenship_number[10] = { 0, };
	char address[50] = { 0, };
	char phone_number[15] = { 0, };
	char account_number[20] = {0, };
	int amount_to_deposit = 0;
	char type_of_deposit[20] = { 0, };
	int interest = 0;

	// ******* For Loop
	for (int i = 0; i < number_of_customers; i++) {
		printf("%d Customer Enter", i + 1);

		//1.name
		printf("\nWhat is customer's name? : ");
		scanf_s("%s", name, 10);
		printf("%s", name);
		// ******* Strings operation
		strcpy(c[i].name, name);

		//2. age
		printf("\nWhat is customer's age? : ");
		scanf_s("%d", &age);
		c[i].age = age;

		//3.date of birth
		printf("\nWhat is the date of birth? : ");
		scanf_s("%s", &date_of_birth, 10);
		// ******* Strings operation
		strcpy(c[i].date_of_birth, date_of_birth);

		//4.citizenship number
		printf("\nWhat is the citizenship number? : ");
		scanf_s("%s", &citizenship_number, 10);
		// ******* Strings operation
		strcpy(c[i].citizenship_number, citizenship_number);

		//5.address
		printf("\nWhat is the address? : ");
		scanf_s("%s", &address, 50);
		// ******* Strings operation
		strcpy(c[i].address, address);

		//6.phone number
		printf("\nWhat is the phone number? : ");
		scanf_s("%s", &phone_number, 15);
		// ******* Strings operation
		strcpy(c[i].phone_number, phone_number);

		//7.account number
		printf("\nWhat is the account number? : ");
		scanf_s("%s", &account_number, 20);
		// ******* Strings operation
		strcpy(c[i].account_number, account_number);

		//8.amount to deposit
		printf("\nWhat is the amount to deposit? : ");
		scanf_s("%d", &amount_to_deposit);
		c[i].amount_to_deposit = amount_to_deposit;
		
		//9.type of amount
		printf("\nWhat is the type of deposit account?\n");
		printf("1:saving, 2:current, 3:fixed for 1years, 4:fixed for 2years, 5: fixed for 3years \n");
		
		int num = 0;
		enum _Amount_type at = 1;
		scanf_s("%d", &num);
		at = num;
		printf("\n%d", at);

		// ******* If else
		// ******* Strings operations
		if (at == 1) {
			strcpy(c[i].type_of_deposit, "saving");
		}
		else if (at == 2) {
			strcpy(c[i].type_of_deposit, "current");
		}
		else if (at == 3) {
			strcpy(c[i].type_of_deposit, "fixed_for_1years");
		}
		else if (at == 4) {
			strcpy(c[i].type_of_deposit, "fixed_for_2years");
		}
		else if (at == 5) {
			strcpy(c[i].type_of_deposit, "fixed_for_3years");
		}

		//10.interest
		// ******* Double Pointer
		// ******* Multi-dimensional array
		int** m = malloc(sizeof(int*) * number_of_customers);
		for (int i = 0; i < number_of_customers; i++) {
			m[i] = malloc(sizeof(int) * 2);
		}
		int a = strlen(account_number);

		// ******* Pointer
		char* aa = account_number[a - 1];
		char* bb = account_number[a - 2];

		// ******* Multi-dimensional array
		m[i][0] = atoi(&aa);
		m[i][1] = atoi(&bb);
		interest = m[i][0] + m[i][1];
		c[i].interest = interest;
		
		printf("\n");

		// ******* File handling using fprintf
		fprintf(fp, "Customer %d \n %s | %d | %s | %s | %s | %s | %s | %d | %s\n", i + 1, name, age, date_of_birth, citizenship_number, address, phone_number, account_number, amount_to_deposit, type_of_deposit);
	}

	fclose(fp);

	printf("\nCreated Successfully!!\n");

	printf("\n");
}

//3. update_existing_account : 기존 회원의 정보를 변경한다.
void update_existing_account(FILE* fp, int number_of_customers, struct Customer* c) {
// edit, change the address and phone number of particular customer account

	fp = fopen("D:\\datis.txt", "w");

	int choice = 0;
	printf("Whose information(address and phone number) do you want to edit? \nEnter the number of the customer : ");
	scanf_s("%d", &choice);

	char address[50] = { 0, };
	char phone_number[15] = { 0, };

	printf("Let's edit the information of %d customer!\n ", choice);
	printf("Enter the new address : ");
	scanf_s("%s", &address,50);
	strcpy(c[choice-1].address, address);

	printf("Enter the new phone number : ");

	scanf_s("%s", &phone_number,15);
	strcpy(c[choice - 1].phone_number, phone_number);

	// ******* For Loop
	for (int i = 0; i < number_of_customers; i++) {
		fprintf(fp, "Customer %d \n %s | %d | %s | %s | %s | %s | %s | %d | %s \n", i + 1, c[i].name, c[i].age, c[i].date_of_birth, c[i].citizenship_number, c[i].address, c[i].phone_number, c[i].account_number, c[i].amount_to_deposit, c[i].type_of_deposit);
	}
	fclose(fp);

	printf("\nUpdated Successfully!!\n");
	

	printf("\n");
}

//4. transaction : deposit and withdraw money to and from  a customer account
void transaction(FILE* fp, int number_of_customers, struct Customer* c) {
// deposit and withdraw money to and from  a particular customer account

	fp = fopen("D:\\datis.txt", "w");
	int amount_to_deposit = 0;
	
	int i = 0;
	printf("Whose depoist do you want to transaction? Enter the number of the customer! : ");
	scanf_s("%d", &i);

	printf("Which one do you want?, deposit or withdraw? \n1 : Deposit | 2 : Withdraw \n");
	int choice;
	scanf_s("%d", &choice);
	printf("\n");

	// ******* If else
	if (choice == 1) {
		int money = 0;
		printf("How much are you going to deposit? : ");
		scanf_s("%d", &money);

		printf("%d", c[i - 1].amount_to_deposit);

		c[i - 1].amount_to_deposit = c[i - 1].amount_to_deposit + money;

		printf("\n%d", c[i - 1].amount_to_deposit);
	}
	else if (choice == 2) {
		int money = 0;
		printf("How much are you going to withdraw? : ");
		scanf_s("%d", &money);

		c[i - 1].amount_to_deposit = c[i - 1].amount_to_deposit - money;

		printf("\n%d", c[i - 1].amount_to_deposit);
	}

	// ******* For Loop
	for (int i = 0; i < number_of_customers; i++) {
		fprintf(fp, "Customer %d \n %s | %d | %s | %s | %s | %s | %s | %d | %s\n", i + 1, c[i].name, c[i].age, c[i].date_of_birth, c[i].citizenship_number, c[i].address, c[i].phone_number, c[i].account_number, c[i].amount_to_deposit, c[i].type_of_deposit);
	}
	fclose(fp);

	printf("\nTransacted Successfully!!\n");

	printf("\n");
}

void check_the_details(int number_of_customers, struct Customer* c) {
// particular account
// account number, name, date of birth, citizenship number,age, address, phone number, type of account, amount deposited, date of deposit, amount of interest
// compute interest by using multidimensional array

	printf("Whose information do you want to search? : ");
	int choice = 0;
	scanf_s("%d", &choice);
	printf("This is the information of customer[%d]\n", choice - 1);
	printf("\n");
	printf("Customer %d \n", choice);
	printf("name : %s\n", c[choice - 1].name);
	printf("age : %d\n", c[choice - 1].age);
	printf("Date of birth : %s\n", c[choice - 1].date_of_birth);
	printf("Citizenship number : %s\n", c[choice - 1].citizenship_number);
	printf("Address : %s\n", c[choice - 1].address);
	printf("Phone number : %s\n", c[choice - 1].phone_number);
	printf("Account number : %s\n", c[choice - 1].account_number);
	printf("Amount to deposit : %d\n", c[choice - 1].amount_to_deposit);
	printf("Type of deposit : %s\n", c[choice - 1].type_of_deposit);

	// ******* If else
	if (strcmp(c[choice - 1].type_of_deposit,"saving") == 0) {
		printf("\n interest is %d\n", c[choice - 1].interest);
	}

	printf("\n");
}

void remove_existing_account(FILE* fp, int number_of_customers, struct Customer* c) {
// delete a customer account

	fp = fopen("D:\\datis.txt", "w");
	int choice = 0;

	// ******* Do-while Loop
	do {
		printf("Whose information do you want to delete? Enter the number of the customer! : ");
		
		scanf_s("%d", &choice);
		// ******* If else
		if (choice > number_of_customers) {
			printf("\n");
			printf("Enter again. Number must not be bigger than the number of customers.\n");
			printf("The number of customers is %d\n", number_of_customers);
			printf("\n");
		}
		else break;
	} while (1);

	// ******* For Loop
	for (int i = choice - 1; i > 0; i--) {
		memcpy(&c[i], &c[i + 1], sizeof(struct Customer));
	}
	memset(&c[number_of_customers], 0, sizeof(struct Customer));

	// ******* For Loop
	for (int i = 0; i < choice-1; i++) {
		fprintf(fp, "Customer %d \n %s | %d | %s | %s | %s | %s | %s | %d | %s  \n", i + 1, c[i].name, c[i].age, c[i].date_of_birth, c[i].citizenship_number, c[i].address, c[i].phone_number, c[i].account_number, c[i].amount_to_deposit, c[i].type_of_deposit);
	}
	// ******* For Loop
	for (int i = choice-1; i < number_of_customers - 1; i++) {
		fprintf(fp, "Customer %d \n %s | %d | %s | %s | %s | %s | %s | %d | %s  \n", i + 2, c[i].name, c[i].age, c[i].date_of_birth, c[i].citizenship_number, c[i].address, c[i].phone_number, c[i].account_number, c[i].amount_to_deposit, c[i].type_of_deposit);
	}

	fclose(fp);

	printf("\nDeleted Successfully!!\n");

	printf("\n");
}

void view_customer_list(int number_of_customers, struct Customer* c) {
// all of customers
// view the list of customer's banking information, account number, name, address, phone number

	char ch = 0;

	int n = 0;

	// ******* Pointer
	FILE* vp = fopen("D:\\datis.txt", "rt");


	// ******* If 
	if (vp == NULL) {
		printf("파일 오픈 실패 !\n");
		return -1;
	}

	// ******* While Loop
	while (1) {
		ch = fgetc(vp);
		if (ch == EOF)

			break;
		putchar(ch);
	}
	fclose(vp);

	printf("\n");
}
