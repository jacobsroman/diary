//
//  TasksController.m
//  Diary
//
//  Created by Mac on 19.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import "TasksController.h"
#import "AppDelegate.h"
#import "TaskCell.h"

#define APP (AppDelegate*)[[UIApplication sharedApplication]delegate]

#define kTaskCellId @"taskCell"
#define kShowEventSegue @"showEvent"

@interface TasksController () <UITableViewDataSource, UITableViewDelegate, EKEventEditViewDelegate, EKEventViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end



@implementation TasksController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![APP taskManager].eventsAccessGranted) {
        [[APP taskManager] requestAccessToEvents];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addButtonAction:(id)sender
{
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    
    // Set addController's event store to the current event store
    addController.eventStore = [APP taskManager].eventStore;
    addController.editViewDelegate = self;
    
    [self presentViewController:addController animated:YES completion:^{
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[APP taskManager]getEvents]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell* cell = [self.tableView dequeueReusableCellWithIdentifier:kTaskCellId forIndexPath:indexPath];
    
    EKEvent *currentEvent = [[[APP taskManager]getEvents] objectAtIndex:indexPath.row];
    cell.titleTextField.text = currentEvent.title;
    return cell;
}

#pragma mark - EKEventEditViewDelegate

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    TasksController * __weak weakSelf = self;
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // Update the UI with the above events
                 [weakSelf.tableView reloadData];
             });
         }
     }];
}

#pragma makr - EKEventViewDelegate
- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.tableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:kShowEventSegue])
    {
        // Configure the destination event view controller
        EKEventViewController* eventViewController = (EKEventViewController *)[segue destinationViewController];
        // Fetch the index path associated with the selected event
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        // Set the view controller to display the selected event
        eventViewController.event = [[[APP taskManager]getEvents] objectAtIndex:indexPath.row];
        eventViewController.delegate = self;
        // Allow event editing
        eventViewController.allowsEditing = YES;
    }
}


@end
