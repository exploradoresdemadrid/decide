/// <reference types="cypress" />

context('Question creation', () => {
  const votingTitle = 'Sample voting 1'

  before(() => {
    cy.clearCookies()
    cy.loginAsAdmin()

    cy.createVoting(votingTitle, {})
    cy.visit('http://localhost:3000/')
  })
  beforeEach(() => {
    Cypress.Cookies.preserveOnce('_decide_session')
  })

  it('create questions in a voting', () => {
    cy.contains(votingTitle).click()
    cy.contains('Questions').click()
    cy.contains('New question').click()

    cy.get('#new_question').contains('Title').click().type('Sample title')
    cy.contains('Add option').click()
    cy.get('.options-form input.form-control').type('Option 1')
    cy.contains('Submit').click()

    cy.get('#notice').should('contain', 'Question was successfully created.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('contain', 'Option 1')
  })

  it('Add option to an existing question', () => {
    cy.get('#questions_index').contains('td', 'Sample title').parent().contains('Edit').click()
    cy.contains('Add option').click()
    cy.get('.options-form input.form-control').last().type('Option 2')
    cy.contains('Submit').click()

    cy.get('#notice').should('contain', 'Question was successfully updated.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('contain', 'Option 1')
    cy.get('#questions_index').should('contain', 'Option 2')
  })

  it('Remove an option to an existing question', () => {
    cy.get('#questions_index').contains('td', 'Sample title').parent().contains('Edit').click()
    cy.get('.remove_fields').contains('Destroy').click()
    cy.contains('Submit').click()

    cy.get('#notice').should('contain', 'Question was successfully updated.')
    cy.get('#questions_index').should('contain', 'Sample title')
    cy.get('#questions_index').should('not.contain', 'Option 1')
    cy.get('#questions_index').should('contain', 'Option 2')
  })
})
