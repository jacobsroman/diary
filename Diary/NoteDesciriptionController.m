//
//  NoteDesciriptionController.m
//  Diary
//
//  Created by Mac on 08.08.15.
//  Copyright (c) 2015 CEIT. All rights reserved.
//

#import "NoteDesciriptionController.h"
#import "NoteCell.h"

#define segueString @"modalConfirm"
#define APP (AppDelegate*)[[UIApplication sharedApplication]delegate]

@interface NoteDesciriptionController ()
<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end

@implementation NoteDesciriptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isNew) {
        self.addButton.title = @"Add";
        self.addButton.enabled = NO;
    }else{
        self.addButton.title = @"Save";
    }
    if (self.note) {
        self.titleTextField.text = self.note.title;
        self.descriptionTextField.text = self.note.noteDescription;
    }
}

- (IBAction)backgrountTapAction:(id)sender
{
    if ([self.titleTextField isFirstResponder]) {
        [self.titleTextField resignFirstResponder];
    }
    if ([self.descriptionTextField isFirstResponder]) {
        [self.descriptionTextField resignFirstResponder];
    }
}

- (IBAction)addButtonAction:(id)sender
{
    NSString* title = self.titleTextField.text;
    NSString* description = self.descriptionTextField.text;
    if (self.isNew) {
        [[APP dataManager]addNewNoteWithTitle:title text:description];
    }else{
        self.note.title = title;
        self.note.noteDescription = description;
        self.note.timeStamp = [NSDate date];
        [[APP dataManager]saveContext];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - Text Delegates
- (IBAction)textFieldEditingChanged:(id)sender
{
    [self configureAddButton];
}

- (void)textViewDidChangeSelection:(UITextView *)textView;
{
    [self configureAddButton];
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text;
{
    [self configureAddButton];
    return YES;
}
*/

- (void)configureAddButton
{
    if (([self.titleTextField.text isEqualToString:@""])||([self.descriptionTextField.text isEqualToString:@""])) {
        self.addButton.enabled = NO;
    }else{
        self.addButton.enabled = YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}
*/

@end
